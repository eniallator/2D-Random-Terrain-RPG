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
    maxChunksToSend = 25,
    mapSeed = 1234,
    tps = 20,
    camera = {
        initialZoom = 30,
        zoomRate = 0.1,
        zoomLimits = {max = 105, min = 6}
    },
    terrain = {
        noise = {
            scale = 200,
            offset = 1000,
            octaves = 4,
            octaveMultiplier = 0.5,
            octaveInfluenceDropoff = 0.5,
            remappingInfluence = 20
        },
        tints = {
            brown = {r = 149 / 255, g = 94 / 255, b = 66 / 255},
            green = {r = 116 / 255, g = 142 / 255, b = 84 / 255},
            blue = {r = 97 / 255, g = 132 / 255, b = 216 / 255},
            yellow = {r = 245 / 255, g = 243 / 255, b = 187 / 255},
            none = {r = 1, g = 1, b = 1}
        },
        biomeMap = {
            -- From the temperature/humidity table here https://minecraft.fandom.com/wiki/Biome
            {
                temperature = {min = 0.8, max = math.huge},
                humidity = {min = -math.huge, max = 0.4},
                name = 'badlands',
                tile = 'dirt',
                tint = 'yellow'
            },
            {
                temperature = {min = 0.8, max = math.huge},
                humidity = {min = 0.4, max = 0.6},
                name = 'desert',
                tile = 'sand',
                tint = 'none'
            },
            {
                temperature = {min = 0.8, max = math.huge},
                humidity = {min = 0.6, max = math.huge},
                name = 'dryForest',
                tile = 'grass',
                tint = 'brown'
            },
            {
                temperature = {min = 0.6, max = 0.8},
                humidity = {min = -math.huge, max = 0.4},
                name = 'savannah',
                tile = 'grass',
                tint = 'yellow'
            },
            {
                temperature = {min = 0.2, max = 0.6},
                humidity = {min = -math.huge, max = 0.6},
                name = 'plains',
                tile = 'grass',
                tint = 'none'
            },
            {
                temperature = {min = 0.6, max = 0.8},
                humidity = {min = 0.4, max = math.huge},
                name = 'jungle',
                tile = 'grass',
                tint = 'green'
            },
            {
                temperature = {min = 0.2, max = 0.6},
                humidity = {min = 0.6, max = math.huge},
                name = 'taiga',
                tile = 'grass',
                tint = 'blue'
            },
            {
                temperature = {min = -math.huge, max = 0.2},
                humidity = {min = 0.2, max = math.huge},
                name = 'snowyPlains',
                tile = 'snow',
                tint = 'none'
            },
            {
                temperature = {min = -math.huge, max = 0.2},
                humidity = {min = -math.huge, max = 0.2},
                name = 'icePlains',
                tile = 'snow',
                tint = 'blue'
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
            targetSqrRadius = 25,
            maxTargets = 4
        }
    },
    entity = {
        player = {
            health = 1000,
            width = 3,
            height = 4,
            inventorySize = 24
        },
        item = {
            dim = 6
        },
        mob = {
            capPerPlayer = 20,
            spawnChance = 0.1,
            spawnRadius = 70,
            despawnRadius = 85
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
