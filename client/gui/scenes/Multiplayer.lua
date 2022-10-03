local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.Grid'

return function(state)
    local multiplayer = BaseGui()
    multiplayer.menu = Grid()

    state.multiplayer = {address = '', port = ''}

    multiplayer.menu:addComponent('label', {value = 1}, {value = 1, weight = 1}, "Enter the server's address:")
    multiplayer.menu:addComponent(
        'textInput',
        {value = 2},
        {value = 1, weight = 1},
        {{tbl = state.multiplayer, key = 'address'}, {r = 0.3, g = 0.3, b = 0.3}}
    )
    multiplayer.menu:addComponent('label', {value = 1}, {value = 2, weight = 1}, 'Port:')
    multiplayer.menu:addComponent(
        'textInput',
        {value = 2},
        {value = 2, weight = 1},
        {{tbl = state.multiplayer, key = 'port'}, {r = 0.3, g = 0.3, b = 0.3}}
    )
    multiplayer.menu:addComponent(
        'button',
        {value = 1},
        {value = 3, weight = 1},
        {
            'Back',
            function(state)
                state.multiplayer = nil
                state.scene = 'mainMenu'
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    multiplayer.menu:addComponent(
        'button',
        {value = 2},
        {value = 3, weight = 1},
        {
            'Connect',
            function(state)
                state.scene = 'game'
            end,
            {r = 0, g = 0.7, b = 0},
            nil,
            function(state)
                return state.multiplayer ~= nil and #state.multiplayer.address == 0 and #state.multiplayer.port == 0
            end
        }
    )

    function multiplayer:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 40, minDim / 60)
        local border = {
            x = width / 4,
            y = height / 5
        }
        self.menu:bakeComponents(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function multiplayer:update(state)
        self:updateMenu(self.menu, state)
    end

    function multiplayer:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    multiplayer:resize(love.graphics.getDimensions())

    return multiplayer
end
