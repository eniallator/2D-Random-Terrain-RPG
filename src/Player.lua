local config = require 'conf'
local Entity = require 'src.Entity'

return function(spriteType)
    local player = Entity(8 / config.tps, 3, 4)

    player.spriteType = spriteType

    player.deltaMoved = 0
    player.nextFrameDistance = 1.5

    player.frameWidth = 16
    player.frameHeight = 24
    player.sprite:setDefaultAnimation('idle')
    player.sprite:addAnimation(
        'idle',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 0,
                width = player.frameWidth,
                height = player.frameHeight
            }
        }
    )
    player.sprite:addAnimation(
        'down',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 0,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight,
                invertX = true
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 0,
                width = player.frameWidth,
                height = player.frameHeight
            }
        }
    )
    player.sprite:addAnimation(
        'right',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 3 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 2 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            }
        }
    )
    player.sprite:addAnimation(
        'left',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 3 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight,
                invertX = true
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 2 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight,
                invertX = true
            }
        }
    )
    player.sprite:addAnimation(
        'up',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 5 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 4 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 5 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight,
                invertX = true
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 4 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            }
        }
    )

    return player
end
