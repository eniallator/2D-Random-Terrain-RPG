local BaseClass = require 'server.class.BaseClass'
local config = require 'conf'
local Projectile = require 'server.Projectile'
-- local Whirlwind = require 'server.projectiles.Whirlwind'

return function()
    local mage = BaseClass()
    local cfg = config.class.mage

    mage:addAbility(
        function(meta, args)
            local newTime = os.clock()
            if meta.lastAttackTime + cfg.attack.cooldown < newTime then
                meta.lastAttackTime = newTime
                local entityData = args.castedBy:getData()
                local diff = {
                    x = args.toPos.x - entityData.pos.current.x,
                    y = args.toPos.y - entityData.pos.current.y
                }
                local directionNorm = {
                    x = diff.x / (math.abs(diff.x) + math.abs(diff.y)),
                    y = diff.y / (math.abs(diff.x) + math.abs(diff.y))
                }
                local whirlwind =
                    Projectile(
                    'whirlwind',
                    args.age,
                    {
                        width = 1,
                        height = 1,
                        speed = config.tps / 8,
                        range = cfg.attack.range,
                        damage = cfg.attack.damage,
                        pos = entityData.pos.current,
                        directionNorm = directionNorm,
                        nextFrameDist = 3.5
                    }
                )
                args.map:addProjectile(whirlwind)
            end
        end,
        {lastAttackTime = os.clock() - cfg.attack.cooldown}
    )

    return mage
end
