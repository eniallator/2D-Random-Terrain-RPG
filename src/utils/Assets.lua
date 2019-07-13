love.graphics.setDefaultFilter('nearest', 'nearest')

return {
    textures = {
        icons = {
            gameIcon = love.graphics.newImage('assets/textures/icons/game-icon.png')
        },
        entity = {
            player = {img = love.graphics.newImage('assets/textures/entity/player.png'), width = 16, height = 24}
        },
        terrain = {
            spritesheet = {img = love.graphics.newImage('assets/textures/terrain/spritesheet.png'), width = 8, height = 8}
        }
    }
}
