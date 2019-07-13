local config = require 'conf'

local tileDim = 8
local tileQuadLookUp = {
    ['Marsh'] = love.graphics.newQuad(
        1 * tileDim,
        1 * tileDim,
        tileDim,
        tileDim,
        ASSETS.textures.terrain.spritesheet:getWidth(),
        ASSETS.textures.terrain.spritesheet:getHeight()
    ),
    ['Grassland'] = love.graphics.newQuad(
        4 * tileDim,
        1 * tileDim,
        tileDim,
        tileDim,
        ASSETS.textures.terrain.spritesheet:getWidth(),
        ASSETS.textures.terrain.spritesheet:getHeight()
    ),
    ['Desert'] = love.graphics.newQuad(
        7 * tileDim,
        1 * tileDim,
        tileDim,
        tileDim,
        ASSETS.textures.terrain.spritesheet:getWidth(),
        ASSETS.textures.terrain.spritesheet:getHeight()
    ),
    ['Snowy'] = love.graphics.newQuad(
        10 * tileDim,
        1 * tileDim,
        tileDim,
        tileDim,
        ASSETS.textures.terrain.spritesheet:getWidth(),
        ASSETS.textures.terrain.spritesheet:getHeight()
    )
}

return function(randomSeed)
    local terrainGenerator = {}

    terrainGenerator.randomSeed = randomSeed

    function terrainGenerator:generate(x, y)
        love.math.setRandomSeed(self.randomSeed)

        temperature = love.math.noise(x / config.terrain.biomeScale, y / config.terrain.biomeScale)
        humidity =
            love.math.noise(
            x / config.terrain.biomeScale + config.terrain.noiseOffset,
            y / config.terrain.biomeScale + config.terrain.noiseOffset
        )

        for name, data in pairs(config.terrain.biomeMap) do
            if
                (data.temperature.min <= temperature and temperature <= data.temperature.max) and
                    (data.humidity.min <= humidity and humidity <= data.humidity.max)
             then
                return tileQuadLookUp[name]
            end
        end
    end

    return terrainGenerator
end
