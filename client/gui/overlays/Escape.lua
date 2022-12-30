local BaseGui = require 'client.gui.BaseGui'
local Button = require 'client.gui.components.Button'

return function()
    local escape = BaseGui()

    escape.menu =
        Button {
        styles = {
            marginLeft = '33%',
            marginTop = '70%',
            marginRight = '33%',
            marginBottom = '10%'
        },
        text = 'Exit to Menu',
        onClick = function(state)
            state.scene = 'mainMenu'
        end
    }

    return escape
end
