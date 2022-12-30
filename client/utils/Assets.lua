love.graphics.setDefaultFilter('nearest', 'nearest')

return {
    fonts = {Psilly = 'client/assets/fonts/Psilly.otf'},
    textures = {
        icons = {
            game = love.graphics.newImage('client/assets/textures/icons/game.png'),
            website = love.graphics.newImage('client/assets/textures/icons/website.png'),
            github = love.graphics.newImage('client/assets/textures/icons/github.png'),
            twitter = love.graphics.newImage('client/assets/textures/icons/twitter.png'),
            linkedin = love.graphics.newImage('client/assets/textures/icons/linkedin.png')
        },
        entity = {
            player = {
                unknown = {
                    img = love.graphics.newImage('client/assets/textures/entity/player/unknown.png'),
                    width = 16,
                    height = 24
                },
                body = {
                    img = love.graphics.newImage('client/assets/textures/entity/player/playerBody.png'),
                    width = 16,
                    height = 24
                },
                hair = {
                    img = love.graphics.newImage('client/assets/textures/entity/player/playerHair.png'),
                    width = 16,
                    height = 24
                },
                eyes = {
                    img = love.graphics.newImage('client/assets/textures/entity/player/playerEyes.png'),
                    width = 16,
                    height = 24
                }
            },
            zombie = {
                knight = {
                    img = love.graphics.newImage('client/assets/textures/entity/zombie/knight.png'),
                    width = 16,
                    height = 20
                },
                bald = {
                    img = love.graphics.newImage('client/assets/textures/entity/zombie/bald.png'),
                    width = 16,
                    height = 18
                }
            }
        },
        inventory = {
            inventorySquare = love.graphics.newImage('client/assets/textures/inventory/inventorySquare.png')
        },
        items = {
            emeraldSword = love.graphics.newImage('client/assets/textures/items/emeraldSword.png')
        },
        projectile = {
            whirlwind = {
                img = love.graphics.newImage('client/assets/textures/projectile/whirlwind.png'),
                width = 16,
                height = 19
            }
        },
        terrain = {
            spritesheet = {
                img = love.graphics.newImage('client/assets/textures/terrain/spritesheet.png'),
                width = 8,
                height = 8
            }
        },
        whiteSquare = love.graphics.newImage('client/assets/textures/whiteSquare.png')
    }
}
