local BaseClass = require 'src.class.BaseClass'
local config = require 'conf'
local Whirlwind = require 'src.projectiles.Whirlwind'

return function()
    local mage = BaseClass()
    local cfg = config.class.mage

    mage:addAbility(
        function(meta, args)
            local newTime = love.timer.getTime() + cfg.attack.cooldown
            if meta.lastAttackTime < newTime then
                meta.lastAttackTime = newTime
                local diff = {
                    x = args.toPos.x - args.entity.hitbox.x,
                    y = args.toPos.y - args.entity.hitbox.y
                }
                local directionNorm = {
                    x = diff.x / (math.abs(diff.x) + math.abs(diff.y)),
                    y = diff.y / (math.abs(diff.x) + math.abs(diff.y))
                }
                local whirlwind = Whirlwind(args.entity.hitbox, directionNorm, {range = cfg.attack.range, damage = cfg.attack.damage})
                args.map:addProjectile(whirlwind)
            end
        end,
        {lastAttackTime = love.timer.getTime() - cfg.attack.cooldown}
    )

    return mage
end
