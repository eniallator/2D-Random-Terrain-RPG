local config = require 'conf'
local OrderedTable = require 'common.utils.OrderedTable'
local Chunk = require 'server.environment.Chunk'
local TerrainGenerator = require 'server.environment.TerrainGenerator'
-- local Zombie = require 'client.Zombie'

return function(mapSeed)
    local map = {}

    map.terrainGenerator = TerrainGenerator(mapSeed)

    map.chunks = {}
    map.mobs = {}
    map.projectiles = {}

    local function getChunks(self, chunkRegion, chunkIdLookup, limit)
        local i, j
        local chunksSet = 0
        local outputChunks = {}
        for i = chunkRegion.startY, chunkRegion.endY do
            for j = chunkRegion.startX, chunkRegion.endX do
                if chunksSet >= limit then
                    return outputChunks
                end
                local chunkID =
                    'x' .. (j < 0 and 'n' or '') .. math.abs(j) .. 'y' .. (i < 0 and 'n' or '') .. math.abs(i)
                if chunkIdLookup[chunkID] == nil then
                    if self.chunks[chunkID] == nil then
                        self.chunks[chunkID] = Chunk(j, i, self.terrainGenerator)
                    end

                    outputChunks[chunkID] = self.chunks[chunkID]:getData()
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
                    startX = math.floor(connection.state.player.pos.x / config.chunkSize - config.playerChunkRadius),
                    startY = math.floor(connection.state.player.pos.y / config.chunkSize - config.playerChunkRadius),
                    endX = math.ceil(connection.state.player.pos.x / config.chunkSize + config.playerChunkRadius),
                    endY = math.ceil(connection.state.player.pos.y / config.chunkSize + config.playerChunkRadius)
                }

                connectionsLocalState[id].environment.lastSent = connection.lastServerTickAge
                connectionsLocalState[id].environment.chunks =
                    getChunks(self, chunkRegion, connection.state.environment.chunkIds, config.maxChunksToSend)
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
