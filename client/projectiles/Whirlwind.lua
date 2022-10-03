local config = require 'conf'
local Hitbox = require 'client.Hitbox'
local BaseProjectile = require 'client.projectiles.BaseProjectile'

return function(fromPos, directionNorm, cfg)
    local whirlwind =
        BaseProjectile(
        {
            width = 1,
            height = 1,
            speed = config.tps / 8,
            range = cfg.range,
            damage = cfg.damage,
            pos = fromPos,
            directionNorm = directionNorm,
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
