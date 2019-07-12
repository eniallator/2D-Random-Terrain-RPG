local config = require 'conf'
local Chunk = require 'src.Chunk'
local TerrainGenerator = require 'src.TerrainGenerator'

return function()
    local map = {}

    map.terrainGenerator = TerrainGenerator(love.timer.getTime())

    map.data = {}

    function map:update(box)
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

                if self.data[chunkID] == nil then
                    self.data[chunkID] = Chunk(j, i, self.terrainGenerator)
                end
            end
        end
    end

    function map:draw(box)
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

                if self.data[chunkID] ~= nil then
                    self.data[chunkID]:draw(
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

    return map
end
