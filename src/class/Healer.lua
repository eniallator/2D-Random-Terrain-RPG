local config = require 'conf'
local Targetter = require 'src.projectiles.Targetter'
local Hitbox = require 'src.Hitbox'

return function()
    local healer = {}
    local cfg = config.class.healer

    healer.lastAttackTime = love.timer.getTime()

    function healer:attack(map, entity, toPos)
        local newTime = love.timer.getTime() + cfg.attack.cooldown
        if self.lastAttackTime < newTime then
            self.lastAttackTime = newTime

            local hitbox = Hitbox(toPos.x, toPos.y, cfg.targetRadius * 2)
            local mobs = map:getMobsOverlapping(hitbox)
            for i = 1, math.min(#mobs, cfg.maxTargets) do
                local targetter = Targetter(entity.hitbox, mobs[i], {range = cfg.attack.range, damage = cfg.attack.damage})
                map:addProjectile(targetter)
            end
        end
    end

    return healer
end
