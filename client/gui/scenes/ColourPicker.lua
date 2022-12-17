local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.Grid'

return function(state)
    local colourPicker = BaseGui()

    colourPicker.menu = Grid()

    colourPicker.menu:addComponent(
        'label',
        {value = 1, weight = 1},
        {value = 1, weight = 1},
        {state.selectedColourLabel}
    )
    colourPicker.menu:addComponent(
        'colourPicker',
        {value = 1, weight = 1},
        {value = 2, weight = 5},
        {state.selectedColourTbl}
    )
    colourPicker.menu:addComponent(
        'label',
        {value = 1, weight = 1},
        {value = 3, weight = 1},
        {'', state.selectedColourTbl}
    )
    colourPicker.menu:addComponent(
        'button',
        {value = 1, weight = 1},
        {value = 4, weight = 1},
        {
            'Save',
            function(state)
                state.selectedColourLabel = nil
                state.selectedColourTbl = nil
                state.scene = 'characterSelect'
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )

    function colourPicker:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 30, minDim / 40)
        local border = {
            x = width / 4,
            y = height / 5
        }
        self.menu:bakeComponents(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function colourPicker:update(state)
        self:updateMenu(self.menu, state)
    end

    function colourPicker:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    colourPicker:resize(love.graphics.getDimensions())

    return colourPicker
end
