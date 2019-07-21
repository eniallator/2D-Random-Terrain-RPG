love.graphics.setDefaultFilter('nearest', 'nearest')

return {
    textures = {
        icons = {
            game = love.graphics.newImage('assets/textures/icons/game.png'),
            website = love.graphics.newImage('assets/textures/icons/website.png'),
            github = love.graphics.newImage('assets/textures/icons/github.png'),
            twitter = love.graphics.newImage('assets/textures/icons/twitter.png')
        },
        entity = {
            player = {img = love.graphics.newImage('assets/textures/entity/player.png'), width = 16, height = 24},
            zombie = {
                knight = {img = love.graphics.newImage('assets/textures/entity/zombie/knight.png'), width = 16, height = 20},
                bald = {img = love.graphics.newImage('assets/textures/entity/zombie/bald.png'), width = 16, height = 18}
            }
        },
        projectile = {
            whirlwind = {img = love.graphics.newImage('assets/textures/projectile/whirlwind.png'), width = 16, height = 19}
        },
        terrain = {
            spritesheet = {img = love.graphics.newImage('assets/textures/terrain/spritesheet.png'), width = 8, height = 8}
        }
    }
}
