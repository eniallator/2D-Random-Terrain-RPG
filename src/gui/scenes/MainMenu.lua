local BaseGui = require 'src.gui.BaseGui'
local Grid = require 'src.gui.Grid'
local ClassLookup = require 'src.class.ClassLookup'

return function(spriteData, nickname, class)
    local mainMenu = BaseGui()

    mainMenu.spriteData = spriteData or {
        hair = {r = 0.8235294117647058, g = 0.49019607843137253, b = 0.17254901960784313},
        eyes = {r = 0, g = 0, b = 0}
    }
    mainMenu.nickname = nickname or 'player'
    mainMenu.selectedClass = class

    mainMenu.menu = Grid()

    local className = 'No class selected'
    if mainMenu.selectedClass ~= nil then
        className = ClassLookup[mainMenu.selectedClass].name
    end

    mainMenu.menu:addComponent('label', {value = 1}, {value = 1, weight = 1}, mainMenu.nickname)
    mainMenu.menu:addComponent('characterDisplay', {value = 1}, {value = 2, weight = 4}, {mainMenu.spriteData, mainMenu.nickname})
    mainMenu.menu:addComponent('label', {value = 1}, {value = 3, weight = 1}, className)
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 4, weight = 1},
        {
            'Select Character',
            function()
                return {setScene = {name = 'characterSelect', args = {mainMenu.spriteData, mainMenu.nickname, mainMenu.selectedClass}}}
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 5, weight = 1},
        {
            'Play',
            function()
                return {
                    setScene = {
                        name = 'game',
                        args = {
                            {spriteData = mainMenu.spriteData, nickname = mainMenu.nickname, class = mainMenu.selectedClass}
                        }
                    }
                }
            end,
            {r = 0, g = mainMenu.selectedClass == nil and 0.3 or 0.7, b = 0},
            {r = 1, g = 1, b = 1},
            mainMenu.selectedClass == nil
        }
    )
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 6, weight = 1},
        {
            'Credits',
            function()
                return {setScene = {name = 'credits', args = {mainMenu.spriteData, mainMenu.nickname, mainMenu.selectedClass}}}
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
        return self:updateMenu(self.menu, {spriteData = self.spriteData})
    end

    function mainMenu:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    mainMenu:resize(love.graphics.getDimensions())

    return mainMenu
end
