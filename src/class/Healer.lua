local config = require 'conf'

return function()
    local healer = {}
    local cfg = config.class.healer

    healer.lastAttackTime = love.timer.getTime()

    function healer:attack(map, entity, toPos)
        print('healer attacked')
    end

    return healer
end
