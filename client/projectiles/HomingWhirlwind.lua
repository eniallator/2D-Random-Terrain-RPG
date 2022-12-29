local config = require 'conf'
local Hitbox = require 'common.types.Hitbox'
local BaseProjectile = require 'client.projectiles.BaseProjectile'

return function(data)
    local targetter =
        BaseProjectile(
        {
            data = data,
            width = 1,
            height = 1,
            pos = fromPos,
            nextFrameDist = 3.5
        }
    )

    local spritesheet = ASSETS.textures.projectile.whirlwind
    targetter.sprite:setDefaultAnimation('moving')
    targetter.sprite:addAnimation(
        'moving',
        spritesheet.img,
        {
            {
                x = 0,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 2 * spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 2 * spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )

    return targetter
end
