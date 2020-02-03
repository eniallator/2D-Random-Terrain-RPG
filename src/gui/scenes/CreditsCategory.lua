local BaseGui = require 'src.gui.BaseGui'
local Grid = require 'src.gui.Grid'
local creditsData = require 'credits'

return function(category, mainMenuData)
    local creditsCategory = BaseGui()
    creditsCategory.menu = Grid()

    creditsCategory.mainMenuData = mainMenuData

    creditsCategory.menu:addComponent('label', {value = 1}, {value = 1, weight = 1}, category .. ' credits')
    creditsCategory.menu:addComponent(
        'credits',
        {value = 1},
        {value = 2, weight = 4},
        {
            creditsData[category],
            {r = 0.5, g = 0.5, b = 0.5, a = 0.7}
        }
    )

    creditsCategory.menu:addComponent(
        'button',
        {value = 1},
        {value = 3, weight = 1},
        {
            'Back',
            function()
                return {setScene = {name = 'credits', args = creditsCategory.mainMenuData}}
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )

    function creditsCategory:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 40, minDim / 60)
        local border = {
            x = width / 4,
            y = height / 5
        }
        self.menu:bakeComponents(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function creditsCategory:update()
        return self:updateMenu(self.menu, self.mainMenuData)
    end

    function creditsCategory:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    creditsCategory:resize(love.graphics.getDimensions())

    return creditsCategory
end
