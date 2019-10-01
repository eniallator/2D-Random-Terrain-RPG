local config = require 'conf'

return function()
    local warrior = {}
    local cfg = config.class.warrior

    warrior.lastAttackTime = love.timer.getTime()

    function warrior:attack(map, entity, toPos)
        print('warrior attacked')
    end

    return warrior
end
