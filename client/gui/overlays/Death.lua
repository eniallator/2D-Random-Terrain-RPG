local BaseGui = require 'client.gui.BaseGui'
local Button = require 'client.gui.components.Button'

return function()
    local death = BaseGui()

    death.worldShader = SHADERS.blackAndWhite

    death.menu =
        Button {
        styles = {
            marginLeft = '33%',
            marginTop = '70%',
            marginRight = '33%',
            marginBottom = '10%'
        },
        text = 'Return to Menu',
        onClick = function(state)
            love.graphics.setShader()
            state.scene = 'mainMenu'
        end
    }

    return death
end
