local BaseComponent = require 'client.gui.components.BaseComponent'

local extraDefaultStyles = {
    background = {r = 0.5, g = 0.5, b = 0.5, a = 1},
    _disabled = {background = {r = 0.3, g = 0.3, b = 0.3, a = 1}}
}

return function(args)
    local button = BaseComponent(args, extraDefaultStyles)

    button.onClick = args.onClick

    return button
end
