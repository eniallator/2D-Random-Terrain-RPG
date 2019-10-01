local config = require 'conf'

return function()
    local archer = {}
    local cfg = config.class.archer

    archer.lastAttackTime = love.timer.getTime()

    function archer:attack(map, entity, toPos)
        print('archer attacked')
    end

    return archer
end
