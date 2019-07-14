local config = require 'conf'
local Chunk = require 'src.Chunk'
local TerrainGenerator = require 'src.TerrainGenerator'
local Zombie = require 'src.Zombie'

return function(player)
    local map = {}

    map.terrainGenerator = TerrainGenerator(love.timer.getTime())

    map.chunks = {}
    map.mobs = {}
    map.player = player

    local function createChunks(self, box)
        local chunkRegion = {
            startX = math.floor((box.x - box.width / 2) / config.chunkSize),
            endX = math.ceil((box.x + box.width / 2) / config.chunkSize),
            startY = math.floor((box.y - box.height / 2) / config.chunkSize),
            endY = math.ceil((box.y + box.height / 2) / config.chunkSize)
        }

        local i, j
        for i = chunkRegion.startY, chunkRegion.endY do
            for j = chunkRegion.startX, chunkRegion.endX do
                local chunkID = 'x' .. j .. 'y' .. i

                if self.chunks[chunkID] == nil then
                    self.chunks[chunkID] = Chunk(j, i, self.terrainGenerator)
                end
            end
        end
    end

    local function updateMobs(self, box)
        local cfg, i = config.entity.mob

        for i = #self.mobs, 1, -1 do
            local absDiff = {
                x = math.abs(self.mobs[i].pos.x - box.x),
                y = math.abs(self.mobs[i].pos.y - box.y)
            }
            if absDiff.x > cfg.despawnRadius or absDiff.y > cfg.despawnRadius then
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

        for i = 1, #self.mobs do
            self.mobs[i]:update()
        end
    end

    function map:update(box)
        createChunks(self, box)
        updateMobs(self, box)
    end

    local function drawChunks(self, box)
        local chunkRegion = {
            startX = math.floor((box.x - box.width / 2) / config.chunkSize),
            endX = math.ceil((box.x + box.width / 2) / config.chunkSize),
            startY = math.floor((box.y - box.height / 2) / config.chunkSize),
            endY = math.ceil((box.y + box.height / 2) / config.chunkSize)
        }

        local i, j
        for i = chunkRegion.startY, chunkRegion.endY do
            for j = chunkRegion.startX, chunkRegion.endX do
                local chunkID = 'x' .. j .. 'y' .. i

                if self.chunks[chunkID] ~= nil then
                    self.chunks[chunkID]:draw(
                        ((j * config.chunkSize) - box.x - box.width / 2) / box.width * love.graphics.getWidth() + love.graphics.getWidth(),
                        ((i * config.chunkSize) - box.y - box.height / 2) / box.height * love.graphics.getHeight() +
                            love.graphics.getHeight(),
                        config.chunkSize * love.graphics.getWidth() / box.width,
                        config.chunkSize * love.graphics.getHeight() / box.height
                    )
                end
            end
        end
    end

    local function drawEntities(self, dt, scale, box)
        self.player:calcDraw(dt, scale)
        self.player:drawShadow(box)

        local i
        for i = 1, #self.mobs do
            self.mobs[i]:calcDraw(dt, scale)
            self.mobs[i]:drawShadow(box)
        end

        local sortedDrawables = {self.player}

        for i = 1, #self.mobs do
            local j = 1
            while sortedDrawables[j] and sortedDrawables[j].drawPos.y < self.mobs[i].drawPos.y do
                j = j + 1
            end
            table.insert(sortedDrawables, j, self.mobs[i])
        end

        for i = 1, #sortedDrawables do
            sortedDrawables[i]:draw(box)
        end
    end

    function map:draw(dt, scale, box)
        drawChunks(self, box)
        drawEntities(self, dt, scale, box)
    end

    return map
end
