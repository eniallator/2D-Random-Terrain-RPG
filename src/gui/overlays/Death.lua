local BaseGui = require 'src.gui.BaseGui'
local Grid = require 'src.gui.Grid'

return function()
    local death = BaseGui()
    death.menu = Grid()

    death.menu:addComponent(
        'button',
        {value = 1},
        {value = 2},
        {
            'Return to Menu',
            function(state)
                love.graphics.setShader()
                return {setScene = {name = 'mainMenu', args = {state.spriteData, state.playerNickname, state.class}}}
            end,
            {r = 0.5, g = 0.5, b = 0.5}
        }
    )

    function death:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 40, minDim / 60)
        local border = {
            x = width / 3,
            y = height * 7 / 16
        }
        self.menu:init(border.x, border.y * 1.5, width - border.x * 2, height - border.y * 2)
    end

    function death:update(state)
        return self:updateMenu(self.menu, state)
    end

    function death:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    death:resize(love.graphics.getDimensions())

    return death
end
