local BaseGui = require 'src.gui.BaseGui'
local Grid = require 'src.gui.Grid'

return function(spriteData, nickname, selectedClass, key, title, initialValue)
    local colourPicker = BaseGui()

    colourPicker.menu = Grid()

    local RGBOutput = {
        r = 1,
        g = 1,
        b = 1
    }

    if initialValue then
        RGBOutput.r = initialValue.r
        RGBOutput.g = initialValue.g
        RGBOutput.b = initialValue.b
    end

    colourPicker.menu:addComponent(
        'label',
        {value = 1, weight = 1},
        {value = 1, weight = 1},
        {title}
    )
    colourPicker.menu:addComponent(
        'colourPicker',
        {value = 1, weight = 1},
        {value = 2, weight = 5},
        {RGBOutput}
    )
    colourPicker.menu:addComponent(
        'label',
        {value = 1, weight = 1},
        {value = 3, weight = 1},
        {'', RGBOutput}
    )
    colourPicker.menu:addComponent(
        'button',
        {value = 1, weight = 1},
        {value = 4, weight = 1},
        {
            'Save',
            function()
                return {
                    setScene = {
                        name = 'characterSelect',
                        args = {spriteData, nickname, selectedClass, key, RGBOutput}
                    }
                }
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
        self.menu:init(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function colourPicker:update()
        return self:updateMenu(self.menu, {selectedSprite = self.selectedSprite, nickname = self.nickname})
    end

    function colourPicker:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    colourPicker:resize(love.graphics.getDimensions())

    return colourPicker
end
