local BaseGui = require 'src.gui.BaseGui'
local Grid = require 'src.gui.Grid'

return function()
    local escape = BaseGui()
    escape.menu = Grid()

    escape.menu:addComponent(
        'button',
        {value = 1},
        {value = 1},
        {
            'Exit to Menu',
            function(state)
                return {setScene = {name = 'mainMenu', args = {state.selectedPlayer, state.playerNickname}}}
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )

    function escape:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 40, minDim / 60)
        local border = {
            x = width / 3,
            y = height * 7 / 16
        }
        self.menu:init(border.x, border.y * 1.5, width - border.x * 2, height - border.y * 2)
    end

    function escape:update(state)
        return self:updateMenu(self.menu, state)
    end

    function escape:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    escape:resize(love.graphics.getDimensions())

    return escape
end
