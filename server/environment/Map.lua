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

    local sqrMobDespawnRadius = config.entity.mob.despawnRadius ^ 2

    local function getChunks(self, chunkRegion, outputChunks, chunksReceived, limit)
        local i, j
        local chunksSet = 0
        local regionWidth = chunkRegion.endX - chunkRegion.startX + 1
        local s = ''
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
        for id, mob in pairs(overlappingMobs) do
            if not mob.data.alive then
                self.mobs[id] = nil
            else
                networkMobsTable[id] = mob.data

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
    end

    local function updateMobs(self, age)
        local i, mob
        for i, mob in pairs(self.mobs) do
            if mob.lastTicked ~= age then
                self.mobs[i] = nil
            else
                mob:update(age)
            end
        end
    end

    local function updatePlayers(self, age, connections)
        local id, player
        for id, player in pairs(self.players) do
            if connections[id] == nil then
                self.players[id] = nil
            else
                if self.players.lastTicked ~= age then
                    -- Simulate player if they haven't sent a packet
                    self.players[id]:update(age)
                end
                connections[id].player = self.players[id].data
            end
        end
        local otherId, otherPlayer
        for id, player in pairs(self.players) do
            for otherId, otherplayer in connections[id].players:subTablePairs() do
                if self.players[otherId] == nil then
                    connections[id].players[otherId] = nil
                end
            end
            for otherId, otherPlayer in pairs(self.players) do
                connections[id].players[otherId] = otherPlayer.data
            end
        end
    end

    local function updateProjectiles(self, box)
        for _, projectile in ipairs(self.projectiles) do
            projectile:update(self.mobs)
        end

        for i = #self.projectiles, 1, -1 do
            if not self.projectiles[i].alive then
                table.remove(self.projectiles, i)
            end
        end
    end

    function map:update(connectionsLocalState, connectionsReceivedState, age)
        if connectionsReceivedState then
            for id, connection in connectionsReceivedState:subTablePairs() do
                if self.players[id] == nil then
                    self.players[id] = Player(connection.state.player)
                end
                self.players[id].lastTicked = age
                self.players[id]:setPosData(connection.state.player.pos)

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
                connectionsLocalState[id].mobs:clear()
                prepareMobs(self, connection.state.player, id, connectionsLocalState[id].mobs, age)
            end
        end
        updatePlayers(self, age, connectionsLocalState)
        updateMobs(self, age)
        -- updateProjectiles(self, box)
    end

    function map:addProjectile(projectile)
        table.insert(self.projectiles, projectile)
    end

    function map:getMobsOverlapping(x, y, sqrRadius)
        local overlappingMobs = {}

        for id, mob in pairs(self.mobs) do
            if collide.getSqrDist(mob.data.pos.current.x, mob.data.pos.current.y, x, y) < sqrRadius then
                overlappingMobs[id] = mob
            end
        end

        return overlappingMobs
    end

    return map
end
