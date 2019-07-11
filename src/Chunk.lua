local config = require 'conf'

return function(x, y)
    local chunk = {}
    chunk.pos = {x = x, y = y}

    local i, j

    chunk.groundTiles = {}
    for i = 1, config.chunkSize do
        table.insert(chunk.groundTiles, {})
        for j = 1, config.chunkSize do
            table.insert(chunk.groundTiles[i], (i + j - 2) / ((config.chunkSize - 2) * 2))
        end
    end

    function chunk:draw(x, y, scale)
        for i = 1, #self.groundTiles do
            for j = 1, #self.groundTiles[i] do
                love.graphics.setColor(self.groundTiles[i][j], self.groundTiles[i][j], self.groundTiles[i][j])
                love.graphics.rectangle('fill', x + (j - 1) * scale, y + (i - 1) * scale, scale, scale)
            end
        end
    end

    return chunk
end
