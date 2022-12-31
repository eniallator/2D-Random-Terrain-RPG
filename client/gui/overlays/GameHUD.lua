local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.Grid'

return function()
    local gameHud = BaseGui('hud')
    gameHud.menu = Grid()

    gameHud.menu:addComponent(
        'button',
        {value = 1},
        {value = 1},
        {
            'Exit to Menu',
            function(state)
                return {setScene = {name = 'mainMenu', args = {state.spriteData, state.playerNickname, state.class}}}
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )

    function gameHud:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 40, minDim / 60)
        local border = {
            x = width / 3,
            y = height * 7 / 16
        }
        self.menu:bakeComponents(border.x, border.y * 1.5, width - border.x * 2, height - border.y * 2)
    end

    function gameHud:update(state)
        return self:updateMenu(self.menu, state)
    end

    function gameHud:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    gameHud:resize(love.graphics.getDimensions())

    return gameHud
end
