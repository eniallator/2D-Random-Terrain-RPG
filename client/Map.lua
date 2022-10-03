local config = require 'conf'
local OrderedTable = require 'common.utils.OrderedTable'
local Chunk = require 'client.Chunk'
-- local Zombie = require 'client.Zombie'

return function(player, mapSeed)
    local map = {}

    map.chunks = {}
    map.mobs = {}
    map.projectiles = {}
    map.player = player

    local function setChunks(self, receivedChunks, idTable)
        for id, chunkData in receivedChunks.subTablePairs() do
            self.chunks[id] = Chunk(chunkData)
            idTable[id] = 1
        end
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

    function map:update(localNetworkState, receivedNetworkState, box)
        if receivedNetworkState and receivedNetworkState.environment.chunks then
            setChunks(self, receivedNetworkState.environment.chunks, localNetworkState.environment.chunkIds)
        end
        -- print(localNetworkState.environment.chunkIds:serialiseUpdates(-1, true))
        -- updateProjectiles(self, box)
        -- updateMobs(self, box)
    end

    function map:addProjectile(projectile)
        table.insert(self.projectiles, projectile)
    end

    function map:getPlayer()
        return self.player
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

    local function drawChunks(self, box)
        local chunkRegion = {
            startX = math.floor((box.x - box.width / 2) / config.chunkSize),
            startY = math.floor((box.y - box.height / 2) / config.chunkSize),
            endX = math.ceil((box.x + box.width / 2) / config.chunkSize),
            endY = math.ceil((box.y + box.height / 2) / config.chunkSize)
        }

        local i, j
        for i = chunkRegion.startY, chunkRegion.endY do
            for j = chunkRegion.startX, chunkRegion.endX do
                local chunkID =
                    'x' .. (j < 0 and 'n' or '') .. math.abs(j) .. 'y' .. (i < 0 and 'n' or '') .. math.abs(i)

                if self.chunks[chunkID] ~= nil then
                    self.chunks[chunkID]:draw(
                        ((j * config.chunkSize) - box.x - box.width / 2) / box.width * love.graphics.getWidth() +
                            love.graphics.getWidth(),
                        ((i * config.chunkSize) - box.y - box.height / 2) / box.height * love.graphics.getHeight() +
                            love.graphics.getHeight(),
                        config.chunkSize * love.graphics.getWidth() / box.width,
                        config.chunkSize * love.graphics.getHeight() / box.height
                    )
                end
            end
        end
    end

    local function drawDrawables(self, dt, box)
        self.player:calcDraw(dt)
        self.player:drawShadow(box)

        -- for _, mob in ipairs(self.mobs) do
        --     mob:calcDraw(dt)
        --     mob:drawShadow(box)
        -- end

        -- for _, projectile in ipairs(self.projectiles) do
        --     projectile:calcDraw(dt)
        -- end

        -- local sortedDrawables = OrderedTable()
        -- sortedDrawables:add(self.player.drawPos.y, self.player)

        -- for _, mob in ipairs(self.mobs) do
        --     sortedDrawables:add(mob.drawPos.y, mob)
        -- end

        -- for _, projectile in ipairs(self.projectiles) do
        --     sortedDrawables:add(projectile.drawPos.y, projectile)
        -- end

        -- sortedDrawables:iterate(
        --     function(drawable)
        --         drawable:draw(box)
        --     end
        -- )
    end

    function map:draw(localNetworkState, receivedNetworkState, dt, box)
        drawChunks(self, box)
        drawDrawables(self, dt, box)
    end

    return map
end
