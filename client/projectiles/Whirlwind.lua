local config = require 'conf'
local BaseProjectile = require 'client.projectiles.BaseProjectile'

return function(data)
    local whirlwind =
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
    whirlwind.sprite:setDefaultAnimation('moving')
    whirlwind.sprite:addAnimation(
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
                x = 3 * spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )

    return whirlwind
end
