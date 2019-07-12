function love.conf(t)
    t.window.resizable = true
    t.window.icon = 'assets/textures/icons/game-icon.png'
    t.title = '2D RPG'
    t.console = true
end

return {
    development = true,
    chunkSize = 16,
    tps = 20,
    camera = {
        initialScale = 30,
        zoomRate = 0.1,
        zoomLimits = {max = 105, min = 6}
    },
    terrain = {
        biomeScale = 100,
        noiseOffset = 10,
        biomeMap = {
            ['Cold Rocky'] = {
                temperature = {min = 0, max = 0.33},
                humidity = {min = 0, max = 0.5},
                colour = {r = 0.3359375, g = 0.3984375, b = 0.4765625}
            },
            ['Frozen Lake'] = {
                temperature = {min = 0, max = 0.33},
                humidity = {min = 0.5, max = 1},
                colour = {r = 0.56640625, g = 0.97265625, b = 0.89453125}
            },
            ['Grassland'] = {
                temperature = {min = 0.33, max = 0.66},
                humidity = {min = 0, max = 0.5},
                colour = {r = 0.6875, g = 0.85546875, b = 0.26171875}
            },
            ['Swamp'] = {
                temperature = {min = 0.33, max = 0.66},
                humidity = {min = 0.5, max = 1},
                colour = {r = 0.21875, g = 0.40625, b = 0.4140625}
            },
            ['Desert'] = {
                temperature = {min = 0.66, max = 1},
                humidity = {min = 0, max = 0.5},
                colour = {r = 0.953125, g = 0.82421875, b = 0.3671875}
            },
            ['Rainforest'] = {
                temperature = {min = 0.66, max = 1},
                humidity = {min = 0.5, max = 1},
                colour = {r = 0.32421875, g = 0.56640625, b = 0.4921875}
            }
        }
    }
}
