love.graphics.setDefaultFilter('nearest', 'nearest')

return {
    textures = {
        icons = {
            gameIcon = love.graphics.newImage('assets/textures/icons/game-icon.png')
        },
        player = {
            spritesheet = love.graphics.newImage('assets/textures/player/spritesheet.png')
        },
        terrain = {
            spritesheet = love.graphics.newImage('assets/textures/terrain/spritesheet.png')
        }
    }
}
