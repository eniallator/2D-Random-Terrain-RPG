local BaseGui = require 'src.gui.BaseGui'
local Grid = require 'src.gui.Grid'
local creditsData = require 'credits'

return function(selectedSprite, nickname)
    local credits = BaseGui()
    credits.menu = Grid()

    credits.mainMenuData = {selectedSprite, nickname}

    local currY = 1
    for category, _ in pairs(creditsData) do
        credits.menu:addComponent(
            'button',
            {value = 1},
            {value = currY, weight = 2},
            {
                category,
                function()
                    return {setScene = {name = 'creditsCategory', args = {category, credits.mainMenuData}}}
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
            function()
                return {setScene = {name = 'mainMenu', args = credits.mainMenuData}}
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
        self.menu:init(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function credits:update()
        return self:updateMenu(self.menu, self.mainMenuData)
    end

    function credits:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    credits:resize(love.graphics.getDimensions())

    return credits
end

-- Potentially change the player textures for https://opengameart.org/content/twelve-more-characters-3-free-characters-and-a-child-template
