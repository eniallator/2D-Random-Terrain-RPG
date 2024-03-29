local config = require 'conf'
local perlin = require 'server.utils.Perlin'

return function(randomSeed)
    local terrainGenerator = {}

    terrainGenerator.randomSeed = randomSeed

    function terrainGenerator:remappingCurve(x)
        return 1 / (1 + math.exp(-config.terrain.noise.remappingInfluence * x)) - 0.5
    end

    function terrainGenerator:generate(x, y)
        local temperature, humidity, divisor, influence, scale, i = 0, 0, 0, 1, config.terrain.noise.scale
        for i = 1, config.terrain.noise.octaves do
            temperature =
                temperature +
                influence *
                    (self:remappingCurve(perlin:noise(x / scale, y / scale, self.randomSeed + divisor * 10)) + 1) /
                    2
            humidity =
                humidity +
                influence *
                    (self:remappingCurve(
                        perlin:noise(
                            x / scale + config.terrain.noise.offset,
                            y / scale + config.terrain.noise.offset,
                            self.randomSeed + divisor * 10
                        )
                    ) +
                        1) /
                    2
            scale = scale * config.terrain.noise.octaveMultiplier
            divisor = divisor + influence
            influence = influence * config.terrain.noise.octaveInfluenceDropoff
        end
        humidity = (humidity / divisor - 0.25) * 2
        temperature = (temperature / divisor - 0.25) * 2

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
