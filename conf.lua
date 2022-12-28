function love.conf(t)
    t.window.resizable = true
    t.window.icon = 'client/assets/textures/icons/game.png'
    t.title = '2D RPG'
    t.console = true
end

return {
    development = true,
    chunkSize = 16,
    playerChunkRadius = 5,
    maxChunksToSend = 40,
    mapSeed = 1234,
    tps = 20,
    camera = {
        initialZoom = 30,
        zoomRate = 0.1,
        zoomLimits = {max = 105, min = 6}
    },
    terrain = {
        biomeScale = 100,
        noiseOffset = 1000,
        biomeMap = {
            {
                temperature = {min = 0.5, max = 1},
                humidity = {min = 0.5, max = 1},
                name = 'Marsh'
            },
            {
                temperature = {min = 0, max = 0.5},
                humidity = {min = 0.5, max = 1},
                name = 'Grassland'
            },
            {
                temperature = {min = 0.5, max = 1},
                humidity = {min = 0, max = 0.5},
                name = 'Desert'
            },
            {
                temperature = {min = 0, max = 0.5},
                humidity = {min = 0, max = 0.5},
                name = 'Snowy'
            }
        }
    },
    class = {
        mage = {
            attack = {
                cooldown = 0.2,
                damage = 100,
                range = 50
            }
        },
        cleric = {
            attack = {
                cooldown = 0.3,
                damage = 30,
                range = 70
            },
            targetRadius = 5,
            maxTargets = 4
        }
    },
    entity = {
        player = {
            health = 1000,
            width = 3,
            height = 4
        },
        item = {
            dim = 6
        },
        mob = {
            capPerPlayer = 20,
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
            sqrAgroRange = {start = 225, stop = 400}
        }
    },
    communication = {
        address = 'localhost',
        port = 3000,
        timeoutTicks = 201
    }
}
