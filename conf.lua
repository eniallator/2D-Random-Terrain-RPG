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
        initialZoom = 30,
        zoomRate = 0.1,
        zoomLimits = {max = 105, min = 6}
    },
    terrain = {
        biomeScale = 200,
        noiseOffset = 1000,
        biomeMap = {
            ['Marsh'] = {
                temperature = {min = 0.5, max = 1},
                humidity = {min = 0.5, max = 1}
            },
            ['Grassland'] = {
                temperature = {min = 0, max = 0.5},
                humidity = {min = 0.5, max = 1}
            },
            ['Desert'] = {
                temperature = {min = 0.5, max = 1},
                humidity = {min = 0, max = 0.5}
            },
            ['Snowy'] = {
                temperature = {min = 0, max = 0.5},
                humidity = {min = 0, max = 0.5}
            }
        }
    }
}
