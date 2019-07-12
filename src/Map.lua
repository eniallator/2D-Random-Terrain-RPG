local config = require 'conf'
local Chunk = require 'src.Chunk'

return function()
    local map = {}

    map.data = {}

    function map:update(x, y, width, height)
        local scale = love.graphics.getWidth() / width
        local i, j

        local chunkRegion = {
            startX = math.floor((x - width / 2) / config.chunkSize / scale),
            endX = math.ceil((x + width / 2) / config.chunkSize / scale),
            startY = math.floor((y - height / 2) / config.chunkSize / scale),
            endY = math.ceil((y + height / 2) / config.chunkSize / scale)
        }

        print(serialise(chunkRegion))

        for i = chunkRegion.startX, chunkRegion.endX do
            for j = chunkRegion.startY, chunkRegion.endY do
                local chunkID = 'x' .. j .. 'y' .. i

                if self.data[chunkID] == nil then
                    self.data[chunkID] = Chunk()
                end
            end
        end
    end

    function map:draw(x, y, width, height)
        local scale = love.graphics.getWidth() / width
        local i, j

        local chunkRegion = {
            startX = math.floor(x / config.chunkSize / scale),
            endX = math.ceil((x + width) / config.chunkSize / scale),
            startY = math.floor(y / config.chunkSize / scale),
            endY = math.ceil((y + height) / config.chunkSize / scale)
        }

        for i = chunkRegion.startX, chunkRegion.endX do
            for j = chunkRegion.startY, chunkRegion.endY do
                local chunkID = 'x' .. j .. 'y' .. i

                if self.data[chunkID] ~= nil then
                    self.data[chunkID]:draw(j * config.chunkSize * scale, i * config.chunkSize * scale, scale)
                end
            end
        end
    end

    return map
end
