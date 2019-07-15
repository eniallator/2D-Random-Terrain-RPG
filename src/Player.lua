local config = require 'conf'
local Entity = require 'src.Entity'

return function(spriteType, nickname)
    local player =
        Entity(
        {
            speed = 8 / config.tps,
            width = 3,
            height = 4,
            nextFrameDistance = 1.5,
            maxHealth = config.entity.player.health,
            label = nickname
        }
    )

    player.spriteType = spriteType
    player.nickname = nickname

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
