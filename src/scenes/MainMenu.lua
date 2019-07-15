local Scene = require 'src.scenes.Scene'
local Grid = require 'src.gui.Grid'

return function()
    local mainMenu = {}

    mainMenu.selectedPlayer = 1

    mainMenu.menu = Grid()

    mainMenu.menu:addComponent(
        'button',
        {value = 2, weight = 2},
        {value = 2, weight = 1},
        {
            'Play',
            function()
                return {setScene = {name = 'game', args = {mainMenu.selectedPlayer}}}
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    mainMenu.menu:addComponent(
        'button',
        {value = 1, weight = 1},
        {value = 1, weight = 4},
        {
            '<',
            function()
                mainMenu.selectedPlayer = (mainMenu.selectedPlayer - 2) % 12 + 1
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    mainMenu.menu:addComponent('characterDisplay', {value = 2}, {value = 1}, {mainMenu.selectedPlayer})
    mainMenu.menu:addComponent(
        'button',
        {value = 3, weight = 1},
        {value = 1},
        {
            '>',
            function()
                mainMenu.selectedPlayer = mainMenu.selectedPlayer % 12 + 1
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )

    local minDim = math.min(love.graphics.getDimensions())
    mainMenu.menu:setPadding(minDim / 40, minDim / 60)
    local border = {
        x = love.graphics.getWidth() / 4,
        y = love.graphics.getHeight() / 5
    }
    mainMenu.menu:init(border.x, border.y, love.graphics.getWidth() - border.x * 2, love.graphics.getHeight() - border.y * 2)

    function mainMenu:update()
        local returnData = {}
        local state = {selectedPlayer = self.selectedPlayer}
        for _, component in ipairs(self.menu:getComponents()) do
            local data = component:update(state)
            if data ~= nil then
                table.insert(returnData, data)
            end
        end
        return #returnData > 0 and returnData or nil
    end

    function mainMenu:draw(dt)
        for _, component in ipairs(self.menu:getComponents()) do
            component:draw()
        end
    end

    return mainMenu
end
