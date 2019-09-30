local config = require 'conf'

return function(box)
    local minimap = {}

    minimap.box = box

    function minimap:draw(cameraBox, map)
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.rectangle('fill', self.box.x, self.box.y, self.box.width, self.box.height)

        local exactLength = config.minimap.radius / config.dotsPerChunkAxis
        local length = math.ceil(exactLength)
        local chunkRegion = {
            startX = cameraBox.x / config.chunkSize - length,
            startY = cameraBox.y / config.chunkSize - length,
            endX = cameraBox.x / config.chunkSize + length,
            endY = cameraBox.y / config.chunkSize + length
        }

        local i, j
        for i = chunkRegion.starty, chunkRegion.endY do
            for j = chunkRegion.startX, chunkRegion.endX do
                local chunk = map.getChunk(j, i)
                if chunk then
                    local dots = chunk:getMinimapDots()
                end
            end
        end
    end

    return minimap
end
