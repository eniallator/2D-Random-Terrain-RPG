local config = require 'conf'
local simplex = require 'server.utils.Simplex'

return function(randomSeed)
    local terrainGenerator = {}

    terrainGenerator.randomSeed = randomSeed

    function terrainGenerator:generate(x, y)
        -- love.math.setRandomSeed(self.randomSeed)

        local temperature, humidity, scale, i = 0, 0, config.terrain.noise.scale
        for i = 1, config.terrain.noise.octaves do
            temperature = temperature + simplex.Noise3D(x / scale, y / scale, self.randomSeed)
            humidity =
                humidity +
                simplex.Noise3D(
                    x / scale + config.terrain.noise.offset,
                    y / scale + config.terrain.noise.offset,
                    self.randomSeed
                )
            scale = scale * config.terrain.noise.octaveMultiplier
        end

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
