local config = require 'myConf'

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

    function chunk:drawGroundTiles(x, y)
        for i = 1, #self.groundTiles do
            for j = 1, #self.groundTiles[i] do
                love.graphics.setColor(self.groundTiles[i][j], self.groundTiles[i][j], self.groundTiles[i][j])
                love.graphics.rectangle('fill', x + (j - 1) * 10, y + (i - 1) * 10, 10, 10)
            end
        end
    end

    return chunk
end
