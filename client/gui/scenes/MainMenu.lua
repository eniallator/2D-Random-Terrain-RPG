local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.Grid'
local ClassesEnum = require 'common.types.ClassesEnum'

return function(state)
    local mainMenu = BaseGui()

    if state.spriteData == nil then
        state.spriteData = {
            hair = {r = 210 / 255, g = 125 / 255, b = 44 / 255},
            eyes = {r = 0, g = 0, b = 0}
        }
    end

    mainMenu.menu = Grid()

    mainMenu.menu:addComponent('label', {value = 1}, {value = 1, weight = 1}, state.nickname)
    mainMenu.menu:addComponent('characterDisplay', {value = 1}, {value = 2, weight = 4}, {state.spriteData})
    mainMenu.menu:addComponent(
        'label',
        {value = 1},
        {value = 3, weight = 1},
        state.class == nil and 'No class selected' or ClassesEnum[ClassesEnum.byValue[state.class]].label
    )
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 4, weight = 1},
        {
            'Select Character',
            function(state)
                state.scene = 'characterSelect'
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 5, weight = 1},
        {
            'Host',
            function(state)
                state.scene = 'game'
            end,
            {r = 0, g = state.class == nil and 0.3 or 0.7, b = 0},
            {r = 1, g = 1, b = 1},
            function(state)
                return state.class == nil
            end
        }
    )
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 6, weight = 1},
        {
            'Connect to a host',
            function(state)
                state.scene = 'multiplayer'
            end,
            {r = 0, g = state.class == nil and 0.3 or 0.7, b = 0},
            {r = 1, g = 1, b = 1},
            function(state)
                return state.class == nil
            end
        }
    )
    mainMenu.menu:addComponent(
        'button',
        {value = 1},
        {value = 7, weight = 1},
        {
            'Credits',
            function(state)
                state.scene = 'credits'
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
        self.menu:bakeComponents(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function mainMenu:update(state)
        self:updateMenu(self.menu, state)
    end

    function mainMenu:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    mainMenu:resize(love.graphics.getDimensions())

    return mainMenu
end
