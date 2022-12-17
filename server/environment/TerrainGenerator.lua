local config = require 'conf'
local simplex = require 'server.utils.Simplex'

return function(randomSeed)
    local terrainGenerator = {}

    terrainGenerator.randomSeed = randomSeed

    function terrainGenerator:generate(x, y)
        -- love.math.setRandomSeed(self.randomSeed)

        temperature = (simplex.Noise2D(x / config.terrain.biomeScale, y / config.terrain.biomeScale) + 1) / 2
        humidity =
            (simplex.Noise2D(
            x / config.terrain.biomeScale + config.terrain.noiseOffset,
            y / config.terrain.biomeScale + config.terrain.noiseOffset
        ) +
            1) /
            2

        for i, data in ipairs(config.terrain.biomeMap) do
            if
                (data.temperature.min <= temperature and temperature <= data.temperature.max) and
                    (data.humidity.min <= humidity and humidity <= data.humidity.max)
             then
                return i
            end
        end
    end

    return terrainGenerator
end
