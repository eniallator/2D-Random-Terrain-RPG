local config = require 'conf'
local Entity = require 'client.Entity'
local BaseInventory = require 'client.items.BaseInventory'

return function(spriteData, nickname, class, isLocal)
    local player =
        Entity(
        {
            speed = 8 / config.tps,
            width = config.entity.player.width,
            height = config.entity.player.height,
            nextFrameDist = 1.5,
            maxHealth = config.entity.player.health,
            label = nickname,
            layeredSprite = true,
            isLocal = isLocal
        }
    )

    -- if class ~= nil then
    --     player.class = class.init()
    -- end

    player.spriteType = 1 or spriteType
    player.nickname = nickname
    player.inventory = BaseInventory(45)

    local spritesheets = {
        {
            spritesheet = ASSETS.textures.entity.player.body,
            tint = {r = 1, g = 1, b = 1}
        },
        {
            spritesheet = ASSETS.textures.entity.player.hair,
            tint = spriteData.hair
        },
        {
            spritesheet = ASSETS.textures.entity.player.eyes,
            tint = spriteData.eyes
        }
    }

    spritesheets.width = spritesheets[1].spritesheet.img:getWidth()
    spritesheets.height = spritesheets[1].spritesheet.img:getHeight()

    local spriteWidth = spritesheets[1].spritesheet.width
    local spriteHeight = spritesheets[1].spritesheet.height

    player.sprite:setDefaultAnimation('idle')
    player.sprite:addAnimation(
        'idle',
        spritesheets,
        {
            {
                x = 0,
                y = 0,
                width = spriteWidth,
                height = spriteHeight
            }
        }
    )
    player.sprite:addAnimation(
        'down',
        spritesheets,
        {
            {
                x = 0,
                y = spriteHeight,
                width = spriteWidth,
                height = spriteHeight
            },
            {
                x = 0,
                y = 0,
                width = spriteWidth,
                height = spriteHeight
            },
            {
                x = 0,
                y = spriteHeight,
                width = spriteWidth,
                height = spriteHeight,
                invertX = true
            },
            {
                x = 0,
                y = 0,
                width = spriteWidth,
                height = spriteHeight,
                invertX = true
            }
        }
    )
    player.sprite:addAnimation(
        'right',
        spritesheets,
        {
            {
                x = 0,
                y = 3 * spriteHeight,
                width = spriteWidth,
                height = spriteHeight
            },
            {
                x = 0,
                y = 2 * spriteHeight,
                width = spriteWidth,
                height = spriteHeight
            }
        }
    )
    player.sprite:addAnimation(
        'left',
        spritesheets,
        {
            {
                x = 0,
                y = 3 * spriteHeight,
                width = spriteWidth,
                height = spriteHeight,
                invertX = true
            },
            {
                x = 0,
                y = 2 * spriteHeight,
                width = spriteWidth,
                height = spriteHeight,
                invertX = true
            }
        }
    )
    player.sprite:addAnimation(
        'up',
        spritesheets,
        {
            {
                x = 0,
                y = 5 * spriteHeight,
                width = spriteWidth,
                height = spriteHeight
            },
            {
                x = 0,
                y = 4 * spriteHeight,
                width = spriteWidth,
                height = spriteHeight
            },
            {
                x = 0,
                y = 5 * spriteHeight,
                width = spriteWidth,
                height = spriteHeight,
                invertX = true
            },
            {
                x = 0,
                y = 4 * spriteHeight,
                width = spriteWidth,
                height = spriteHeight,
                invertX = true
            }
        }
    )

    return player
end
