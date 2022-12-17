local BaseClass = require 'client.class.BaseClass'
local config = require 'conf'

return function()
    local warrior = BaseClass()
    local cfg = config.class.warrior

    warrior:addAbility(
        function(meta, args)
            print('warrior attacked')
        end,
        {}
    )

    return warrior
end
