local config = require 'conf'

local spritesheet = ASSETS.textures.terrain.spritesheet
local tileQuadLookUp = {
    ['Marsh'] = love.graphics.newQuad(
        1 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    ),
    ['Grassland'] = love.graphics.newQuad(
        4 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    ),
    ['Desert'] = love.graphics.newQuad(
        7 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
    ),
    ['Snowy'] = love.graphics.newQuad(
        10 * spritesheet.width,
        1 * spritesheet.height,
        spritesheet.width,
        spritesheet.height,
        spritesheet.img:getWidth(),
        spritesheet.img:getHeight()
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
                return {quad = tileQuadLookUp[name], minimapColour = data.minimapColour}
            end
        end
    end

    return terrainGenerator
end
