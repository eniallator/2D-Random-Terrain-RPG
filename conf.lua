function love.conf(t)
    t.window.resizable = true
    t.window.icon = 'assets/textures/icons/game.png'
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
    minimap = {
        dotsPerChunkAxis = 2,
        radius = 20
    },
    terrain = {
        biomeScale = 200,
        noiseOffset = 1000,
        biomeMap = {
            ['Marsh'] = {
                temperature = {min = 0.5, max = 1},
                humidity = {min = 0.5, max = 1},
                minimapColour = {r = 0.29296875, g = 0.25390625, b = 0.14453125}
            },
            ['Grassland'] = {
                temperature = {min = 0, max = 0.5},
                humidity = {min = 0.5, max = 1},
                minimapColour = {r = 0.234375, g = 0.37109375, b = 0.08203125}
            },
            ['Desert'] = {
                temperature = {min = 0.5, max = 1},
                humidity = {min = 0, max = 0.5},
                minimapColour = {r = 0.87890625, g = 0.8203125, b = 0.515625}
            },
            ['Snowy'] = {
                temperature = {min = 0, max = 0.5},
                humidity = {min = 0, max = 0.5},
                minimapColour = {r = 0.921875, g = 0.984375, b = 0.99609375}
            }
        }
    },
    projectile = {
        whirlwind = {
            damage = 100,
            range = 50
        }
    },
    class = {
        mage = {
            attack = {
                cooldown = 0.2,
                damage = 100,
                range = 50
            }
        }
    },
    entity = {
        player = {
            health = 1000
        },
        mob = {
            cap = 30,
            spawnChance = 0.1,
            spawnRadius = 120,
            despawnRadius = 150
        },
        zombie = {
            health = 1000,
            attack = {
                cooldown = 0.5,
                range = 1,
                damage = 50
            },
            idleTime = {min = 3, max = 7},
            walkRange = {min = 5, max = 20},
            agroRange = {start = 15, stop = 20}
        }
    }
}
