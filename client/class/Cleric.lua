local BaseClass = require 'client.class.BaseClass'
local config = require 'conf'
local Targetter = require 'client.projectiles.Targetter'
local Hitbox = require 'common.types.Hitbox'

return function()
    local cleric = BaseClass()
    local cfg = config.class.cleric

    cleric:addAbility(
        function(meta, args)
            local newTime = love.timer.getTime() + cfg.attack.cooldown
            if meta.lastAttackTime < newTime then
                meta.lastAttackTime = newTime

                local hitbox = Hitbox(args.toPos.x, args.toPos.y, cfg.targetRadius * 2)
                local mobs = args.map:getMobsOverlapping(hitbox)
                for i = 1, math.min(#mobs, cfg.maxTargets) do
                    local targetter =
                        Targetter(args.entity.hitbox, mobs[i], {range = cfg.attack.range, damage = cfg.attack.damage})
                    args.map:addProjectile(targetter)
                end
            end
        end,
        {lastAttackTime = love.timer.getTime() - cfg.attack.cooldown}
    )

    return cleric
end
