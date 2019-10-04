local config = require 'conf'
local Targetter = require 'src.projectiles.Targetter'
local Hitbox = require 'src.Hitbox'

return function()
    local cleric = {}
    local cfg = config.class.cleric

    cleric.lastAttackTime = love.timer.getTime()

    function cleric:attack(map, entity, toPos)
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

    return cleric
end
