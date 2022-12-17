local config = require 'conf'
local OrderedTable = require 'common.utils.OrderedTable'
local posToId = require 'common.utils.posToId'
local Chunk = require 'server.environment.Chunk'
local TerrainGenerator = require 'server.environment.TerrainGenerator'
-- local Zombie = require 'client.Zombie'

return function(mapSeed)
    local map = {}

    map.terrainGenerator = TerrainGenerator(mapSeed)

    map.chunks = {}
    map.mobs = {}
    map.projectiles = {}

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

    local function updateMobs(self, box)
        local cfg, i = config.entity.mob

        for i = #self.mobs, 1, -1 do
            local absDiff = {
                x = math.abs(self.mobs[i].hitbox.x - box.x),
                y = math.abs(self.mobs[i].hitbox.y - box.y)
            }
            if absDiff.x > cfg.despawnRadius or absDiff.y > cfg.despawnRadius or not self.mobs[i].alive then
                table.remove(self.mobs, i)
            end
        end

        if #self.mobs < cfg.cap and math.random() < cfg.spawnChance then
            local zombieType = math.ceil(math.random() * 5)
            local spawnPos = {
                x = box.x - cfg.spawnRadius / 2 + math.random() * cfg.spawnRadius,
                y = box.y - cfg.spawnRadius / 2 + math.random() * cfg.spawnRadius
            }
            table.insert(self.mobs, Zombie(zombieType, spawnPos.x, spawnPos.y))
        end

        for _, mob in ipairs(self.mobs) do
            mob:update(self)
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

    function map:update(connectionsLocalState, connectionsReceivedState)
        if connectionsReceivedState then
            for id, connection in connectionsReceivedState.subTablePairs() do
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
                connectionsLocalState[id].environment.chunks =
                    getChunks(self, chunkRegion, connection.state.environment.chunksReceived, config.maxChunksToSend)
            end
        end
        -- updateProjectiles(self, box)
        -- updateMobs(self, box)
    end

    function map:addProjectile(projectile)
        table.insert(self.projectiles, projectile)
    end

    function map:getMobsOverlapping(hitbox)
        local overlappingMobs = {}

        for _, mob in pairs(self.mobs) do
            if mob.hitbox:collide(hitbox) then
                table.insert(overlappingMobs, mob)
            end
        end

        return overlappingMobs
    end

    return map
end
