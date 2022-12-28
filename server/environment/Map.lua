local config = require 'conf'
local OrderedTable = require 'common.types.OrderedTable'
local posToId = require 'common.utils.posToId'
local collide = require 'common.utils.collide'
local Chunk = require 'server.environment.Chunk'
local TerrainGenerator = require 'server.environment.TerrainGenerator'
local Zombie = require 'server.Zombie'

return function(mapSeed)
    local map = {}

    map.terrainGenerator = TerrainGenerator(mapSeed)

    map.chunks = {}
    map.mobs = {}
    map.mobId = 1
    map.projectiles = {}

    local sqrMobDespawnRadius = config.entity.mob.despawnRadius ^ 2

    local function getChunks(self, chunkRegion, chunksReceived, limit)
        local i, j
        local chunksSet = 0
        local outputChunks = {}
        local regionWidth = chunkRegion.endX - chunkRegion.startX + 1
        local s = ''
        for i = 0, chunkRegion.endY - chunkRegion.startY do
            for j = 0, chunkRegion.endX - chunkRegion.startX do
                if chunksSet >= limit then
                    return outputChunks
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
        return outputChunks
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
            if not mob.alive then
                self.mobs[id] = nil
            else
                networkMobsTable[id] = mob.data

                if mob.lastTicked ~= age then
                    mob.nearbyPlayers = {byId = {[playerId] = player}, {entity = player, id = playerId}}
                else
                    mob.nearbyPlayers.byId[playerId] = player
                    mob.nearbyPlayers[#mob.nearbyPlayers + 1] = {entity = player, id = playerId}
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
                connectionsLocalState[id].environment.chunks =
                    getChunks(self, chunkRegion, connection.state.environment.chunksReceived, config.maxChunksToSend)
                connectionsLocalState[id].mobs:clear()
                prepareMobs(self, connection.state.player, id, connectionsLocalState[id].mobs, age)
            end
        end
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
