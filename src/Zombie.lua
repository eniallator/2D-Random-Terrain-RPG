local config = require 'conf'
local Entity = require 'src.Entity'
local EnemyBehaviour = require 'src.EnemyBehaviour'

local types = {
    {path = ASSETS.textures.entity.zombie.knight, col = 1},
    {path = ASSETS.textures.entity.zombie.knight, col = 2},
    {path = ASSETS.textures.entity.zombie.bald, col = 1},
    {path = ASSETS.textures.entity.zombie.bald, col = 2},
    {path = ASSETS.textures.entity.zombie.bald, col = 3}
}

return function(type, x, y)
    local zombie = Entity(5 / config.tps, 3, 4, 1.5, config.entity.zombie.health)
    local super = Entity(5 / config.tps, 3, 4, 1.5, config.entity.zombie.health)

    zombie.hitbox.x = x
    zombie.hitbox.y = y
    zombie.behaviour = EnemyBehaviour(zombie, config.entity.zombie)

    local spritesheet = types[type].path
    local colOffset = (types[type].col - 1) * 3 * spritesheet.width

    zombie.sprite:setDefaultAnimation('idle')
    zombie.sprite:addAnimation(
        'idle',
        spritesheet.img,
        {
            {
                x = 1 * spritesheet.width + colOffset,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    zombie.sprite:addAnimation(
        'down',
        spritesheet.img,
        {
            {
                x = 2 * spritesheet.width + colOffset,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = colOffset,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    zombie.sprite:addAnimation(
        'right',
        spritesheet.img,
        {
            {
                x = 2 * spritesheet.width + colOffset,
                y = 1 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 1 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = colOffset,
                y = 1 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 1 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    zombie.sprite:addAnimation(
        'left',
        spritesheet.img,
        {
            {
                x = 2 * spritesheet.width + colOffset,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = colOffset,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    zombie.sprite:addAnimation(
        'up',
        spritesheet.img,
        {
            {
                x = 2 * spritesheet.width + colOffset,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = colOffset,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )

    function zombie:update(map)
        self.behaviour:autoUpdate(map)
        super.update(self)
    end

    return zombie
end
