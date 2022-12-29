local config = require 'conf'
local OrderedTable = require 'common.types.OrderedTable'
local posToId = require 'common.utils.posToId'
local collide = require 'common.utils.collide'
local Chunk = require 'server.environment.Chunk'
local TerrainGenerator = require 'server.environment.TerrainGenerator'
local Zombie = require 'server.Zombie'
local Player = require 'server.Player'

return function(mapSeed)
    local map = {}

    map.terrainGenerator = TerrainGenerator(mapSeed)

    map.players = {}
    map.chunks = {}
    map.mobs = {}
    map.mobId = 1
    map.projectiles = {}
    map.projectileId = 1

    local sqrMobDespawnRadius = config.entity.mob.despawnRadius ^ 2

    local function getChunks(self, chunkRegion, outputChunks, chunksReceived, limit)
        local chunksSet = 0
        local regionWidth = chunkRegion.endX - chunkRegion.startX + 1
        local s, i, j = ''
        for i = 0, chunkRegion.endY - chunkRegion.startY do
            for j = 0, chunkRegion.endX - chunkRegion.startX do
                if chunksSet >= limit then
                    return
                end
                local bitIndex = i * regionWidth + j + 1
                if chunksReceived == nil or chunksReceived.length + 1 == bitIndex or chunksReceived:bitAt(bitIndex) == 0 then
                    local chunkId = posToId.forward(j + chunkRegion.startX, i + chunkRegion.startY)
                    if self.chunks[chunkId] == nil then
                        self.chunks[chunkId] =
                            Chunk(j + chunkRegion.startX, i + chunkRegion.startY, self.terrainGenerator)
                    end

                    outputChunks[chunkId] = self.chunks[chunkId]:getData()
                    chunksSet = chunksSet + 1
                end
            end
        end
    end

    local function prepareMobs(self, player, playerId, networkMobsTable, age)
        local cfg = config.entity.mob

        local overlappingMobs = self:getMobsOverlapping(player.pos.current.x, player.pos.current.y, sqrMobDespawnRadius)
        if #overlappingMobs < cfg.capPerPlayer and math.random() < cfg.spawnChance then
            local zombieType = math.ceil(math.random() * 5)
            local spawnPos = {
                x = player.pos.current.x - cfg.spawnRadius / 2 + math.random() * cfg.spawnRadius,
                y = player.pos.current.y - cfg.spawnRadius / 2 + math.random() * cfg.spawnRadius
            }
            self.mobs[self.mobId] = Zombie(zombieType, spawnPos.x, spawnPos.y, age)
            overlappingMobs[self.mobId] = self.mobs[self.mobId]
            self.mobId = self.mobId + 1
        end

        local id, mob
        for id, mob in networkMobsTable:subTablePairs() do
            if overlappingMobs[id] == nil then
                networkMobsTable[id] = nil
            end
        end

        for id, mob in pairs(overlappingMobs) do
            if networkMobsTable[id] == nil then
                networkMobsTable[id] = mob:getData()
            end

            if self.players[playerId].data.alive then
                if mob.lastTicked ~= age then
                    mob.nearbyPlayers = {
                        byId = {[playerId] = self.players[playerId]},
                        {entity = self.players[playerId], id = playerId}
                    }
                else
                    mob.nearbyPlayers.byId[playerId] = self.players[playerId]
                    mob.nearbyPlayers[#mob.nearbyPlayers + 1] = {entity = self.players[playerId], id = playerId}
                end
            elseif mob.lastTicked ~= age then
                mob.nearbyPlayers = {byId = {}}
            end
            mob.lastTicked = age
        end
    end

    local function updateMobs(self, age)
        local i, mob
        for i, mob in pairs(self.mobs) do
            local mobData = mob:getData()
            if not mobData.alive or mob.lastTicked ~= age then
                self.mobs[i] = nil
            else
                mob:update(age)
            end
        end
    end

    local projectileAreaSideLength = config.chunkSize * (config.playerChunkRadius * 2 + 1)
    local function prepareProjectiles(self, player, networkProjectilesTable)
        local overlappingProjectiles =
            self:getProjectilesOverlapping(
            player.pos.current.x,
            player.pos.current.y,
            projectileAreaSideLength,
            projectileAreaSideLength
        )
        local id, projectile
        for id, projectile in networkProjectilesTable:subTablePairs() do
            if overlappingProjectiles[id] == nil then
                networkProjectilesTable[id] = nil
            end
        end
        for id, projectile in pairs(overlappingProjectiles) do
            if networkProjectilesTable[id] == nil then
                networkProjectilesTable[id] = projectile:getData()
            end
        end
    end

    local function updateProjectiles(self)
        local id, projectile
        for id, projectile in pairs(self.projectiles) do
            if projectile.alive then
                projectile:update(self.mobs)
            else
                self.projectiles[id] = nil
            end
        end
    end

    local playerDetailKeys = {'health', 'maxHealth', 'alive'}
    local function updatePlayers(self, age, connections)
        local id, player, otherId, otherPlayer
        for id, player in pairs(self.players) do
            if connections[id] == nil then
                self.players[id] = nil
            else
                self.players[id]:update(age, self, self.players[id].lastTicked ~= age)
                connections[id].player = self.players[id]:getData(playerDetailKeys)
            end
        end
        for id, player in pairs(self.players) do
            for otherId, otherplayer in connections[id].players:subTablePairs() do
                if id ~= otherId and self.players[otherId] == nil then
                    connections[id].players[otherId] = nil
                end
            end
            for otherId, otherPlayer in pairs(self.players) do
                if id ~= otherId then
                    connections[id].players[otherId] = otherPlayer:getData()
                end
            end
        end
    end

    function map:update(connectionsLocalState, connectionsReceivedState, age)
        updateProjectiles(self)
        updateMobs(self, age - 1)
        if connectionsReceivedState then
            local id, connection
            for id, connection in connectionsReceivedState:subTablePairs() do
                if self.players[id] == nil then
                    self.players[id] = Player(connection.state.player)
                end
                self.players[id].lastTicked = age
                if connection.state.player ~= nil then
                    self.players[id]:updateData(connection.state.player)
                end

                local chunkRegion = {
                    startX = math.floor(
                        connection.state.player.pos.current.x / config.chunkSize - config.playerChunkRadius
                    ),
                    startY = math.floor(
                        connection.state.player.pos.current.y / config.chunkSize - config.playerChunkRadius
                    ),
                    endX = math.ceil(
                        connection.state.player.pos.current.x / config.chunkSize + config.playerChunkRadius
                    ),
                    endY = math.ceil(
                        connection.state.player.pos.current.y / config.chunkSize + config.playerChunkRadius
                    )
                }

                connectionsLocalState[id].environment.lastSent = connection.lastServerTickAge
                connectionsLocalState[id].environment.chunks:clear()
                getChunks(
                    self,
                    chunkRegion,
                    connectionsLocalState[id].environment.chunks,
                    connection.state.environment.chunksReceived,
                    config.maxChunksToSend
                )
                prepareMobs(self, connection.state.player, id, connectionsLocalState[id].mobs, age)
                prepareProjectiles(self, connection.state.player, connectionsLocalState[id].projectiles)
            end
        end
        updatePlayers(self, age, connectionsLocalState)
    end

    function map:addProjectile(projectile)
        self.projectiles[self.projectileId] = projectile
        self.projectileId = self.projectileId + 1
    end

    function map:getMobsOverlapping(x, y, sqrRadius)
        local overlappingMobs, id, mob = {}

        for id, mob in pairs(self.mobs) do
            local mobData = mob:getData()
            if collide.getSqrDist(mobData.pos.current.x, mobData.pos.current.y, x, y) < sqrRadius then
                overlappingMobs[id] = mob
            end
        end

        return overlappingMobs
    end

    function map:getProjectilesOverlapping(x, y, width, height)
        local overlappingProjectiles, id, projectile = {}

        for id, projectile in pairs(self.projectiles) do
            local projectileData = projectile:getData()
            if collide.posInside(x, y, width, height, projectileData.pos.current.x, projectileData.pos.current.y) then
                overlappingProjectiles[id] = projectile
            end
        end

        return overlappingProjectiles
    end

    return map
end
