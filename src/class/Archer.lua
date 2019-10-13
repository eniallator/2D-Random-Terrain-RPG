local BaseClass = require 'src.class.BaseClass'
local config = require 'conf'

return function()
    local archer = BaseClass()
    local cfg = config.class.archer

    archer:addAbility(
        function(meta, args)
            print('Archer attacked')
        end,
        {}
    )

    return archer
end
