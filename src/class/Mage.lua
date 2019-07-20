local config = require 'conf'
local Whirlwind = require 'src.projectiles.Whirlwind'

return function()
    local mage = {}
    local cfg = config.class.mage

    mage.lastAttackTime = love.timer.getTime()

    function mage:attack(map, entity, toPos)
        local newTime = love.timer.getTime() + cfg.attack.cooldown
        if mage.lastAttackTime < newTime then
            mage.lastAttackTime = newTime
            local diff = {
                x = toPos.x - entity.hitbox.x,
                y = toPos.y - entity.hitbox.y
            }
            local directionNorm = {
                x = diff.x / (math.abs(diff.x) + math.abs(diff.y)),
                y = diff.y / (math.abs(diff.x) + math.abs(diff.y))
            }
            local whirlwind = Whirlwind(entity.hitbox, directionNorm)
            map:addProjectile(whirlwind)
        end
    end

    return mage
end
