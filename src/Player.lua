local config = require 'conf'
local Entity = require 'src.Entity'

return function(spriteType)
    local player = Entity(8 / config.tps, 3, 4, 1.5, config.entity.player.health)

    player.spriteType = spriteType

    local spritesheet = ASSETS.textures.entity.player
    player.sprite:setDefaultAnimation('idle')
    player.sprite:addAnimation(
        'idle',
        spritesheet.img,
        {
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    player.sprite:addAnimation(
        'down',
        spritesheet.img,
        {
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height,
                invertX = true
            },
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height,
                invertX = true
            }
        }
    )
    player.sprite:addAnimation(
        'right',
        spritesheet.img,
        {
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    player.sprite:addAnimation(
        'left',
        spritesheet.img,
        {
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height,
                invertX = true
            },
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height,
                invertX = true
            }
        }
    )
    player.sprite:addAnimation(
        'up',
        spritesheet.img,
        {
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 5 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 4 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 5 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height,
                invertX = true
            },
            {
                x = (player.spriteType - 1) * spritesheet.width,
                y = 4 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height,
                invertX = true
            }
        }
    )

    return player
end
