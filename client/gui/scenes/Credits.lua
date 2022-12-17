local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.Grid'
local creditsData = require 'credits'

return function(state)
    local credits = BaseGui()
    credits.menu = Grid()

    local currY = 1
    for category, _ in pairs(creditsData) do
        credits.menu:addComponent(
            'button',
            {value = 1},
            {value = currY, weight = 2},
            {
                category,
                function(state)
                    state.creditsCategory = category
                    state.scene = 'creditsCategory'
                end,
                {r = 0, g = 0.7, b = 0}
            }
        )
        currY = currY + 1
    end

    credits.menu:addComponent(
        'button',
        {value = 1},
        {value = currY, weight = 1},
        {
            'Back',
            function(state)
                state.scene = 'mainMenu'
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )

    function credits:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 40, minDim / 60)
        local border = {
            x = width / 4,
            y = height / 5
        }
        self.menu:bakeComponents(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function credits:update(state)
        self:updateMenu(self.menu, state)
    end

    function credits:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    credits:resize(love.graphics.getDimensions())

    return credits
end
