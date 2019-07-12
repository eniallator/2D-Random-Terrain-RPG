local config = require 'conf'

return function(randomSeed)
    local terrainGenerator = {}

    terrainGenerator.randomSeed = randomSeed

    function terrainGenerator:generate(x, y)
        love.math.setRandomSeed(self.randomSeed)

        -- return {
        --     r = love.math.noise(x / config.terrain.biomeScale, y / config.terrain.biomeScale, 0),
        --     g = love.math.noise(x / config.terrain.biomeScale, y / config.terrain.biomeScale, config.terrain.noiseOffset),
        --     b = love.math.noise(x / config.terrain.biomeScale, y / config.terrain.biomeScale, 2 * config.terrain.noiseOffset)
        -- }

        temperature = love.math.noise(x / config.terrain.biomeScale, y / config.terrain.biomeScale, 0)
        humidity = love.math.noise(x / config.terrain.biomeScale, y / config.terrain.biomeScale, config.terrain.noiseOffset)

        for name, data in pairs(config.terrain.biomeMap) do
            if
                (data.temperature.min <= temperature and temperature <= data.temperature.max) and
                    (data.humidity.min <= humidity and humidity <= data.humidity.max)
             then
                return data.colour
            end
        end
    end

    return terrainGenerator
end
