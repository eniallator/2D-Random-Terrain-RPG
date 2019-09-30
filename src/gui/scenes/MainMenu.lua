local BaseGui = require 'src.gui.BaseGui'
local Grid = require 'src.gui.Grid'

return function(selectedSprite, nickname)
    local mainMenu = BaseGui()

    mainMenu.selectedSprite = selectedSprite or nil
    mainMenu.nickname = nickname or 'player'

    mainMenu.menu = Grid()

    mainMenu.menu:addComponent('label', {value = 1}, {value = 1, weight = 1}, mainMenu.nickname)
    mainMenu.menu:addComponent('characterDisplay', {value = 1}, {value = 2, weight = 4}, {mainMenu.selectedSprite, mainMenu.nickname})
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 3, weight = 1},
        {
            'Select Character',
            function()
                return {setScene = {name = 'characterSelect', args = {mainMenu.selectedSprite, mainMenu.nickname}}}
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 4, weight = 1},
        {
            'Play',
            function()
                return {setScene = {name = 'game', args = {{sprite = mainMenu.selectedSprite, nickname = mainMenu.nickname}}}}
            end,
            {r = 0, g = mainMenu.selectedSprite == nil and 0.3 or 0.7, b = 0},
            {r = 1, g = 1, b = 1},
            mainMenu.selectedSprite == nil
        }
    )
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 5, weight = 1},
        {
            'Credits',
            function()
                return {setScene = {name = 'credits', args = {mainMenu.selectedSprite, mainMenu.nickname}}}
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )

    function mainMenu:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 40, minDim / 60)
        local border = {
            x = width / 4,
            y = height / 5
        }
        self.menu:init(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function mainMenu:update()
        return self:updateMenu(self.menu, {selectedSprite = self.selectedSprite})
    end

    function mainMenu:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    mainMenu:resize(love.graphics.getDimensions())

    return mainMenu
end
