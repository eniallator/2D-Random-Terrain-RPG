local config = require 'conf'

return function(x, y, terrainGenerator)
    local chunk = {}
    chunk.pos = {x = x, y = y}

    local i, j

    chunk.groundTiles = {}
    for i = 1, config.chunkSize do
        table.insert(chunk.groundTiles, {})
        for j = 1, config.chunkSize do
            table.insert(chunk.groundTiles[i], terrainGenerator:generate(x * config.chunkSize + j, y * config.chunkSize + i))
        end
    end

    function chunk:draw(x, y, width, height)
        local tileDim = {
            width = width / config.chunkSize,
            height = height / config.chunkSize
        }

        for i = 1, #self.groundTiles do
            for j = 1, #self.groundTiles[i] do
                love.graphics.draw(
                    ASSETS.textures.terrain.spritesheet.img,
                    self.groundTiles[i][j],
                    x + (j - 1) * tileDim.width,
                    y + (i - 1) * tileDim.height,
                    0,
                    tileDim.width / ASSETS.textures.terrain.spritesheet.width,
                    tileDim.height / ASSETS.textures.terrain.spritesheet.height
                )
            end
        end
    end

    return chunk
end
