local Scene = require 'src.scenes.Scene'
local Grid = require 'src.gui.Grid'

return function(selectedSprite, nickname)
    local characterSelect = Scene()

    characterSelect.selectedSprite = selectedSprite or 1
    characterSelect.nickname = nickname or 'default'

    characterSelect.menu = Grid()
    characterSelect.menu:addComponent(
        'button',
        {value = 1, weight = 1},
        {value = 1, weight = 4},
        {
            '<',
            function()
                characterSelect.selectedSprite = (characterSelect.selectedSprite - 2) % 12 + 1
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    characterSelect.menu:addComponent('characterDisplay', {value = 2}, {value = 1}, {characterSelect.selectedSprite})
    characterSelect.menu:addComponent(
        'button',
        {value = 3, weight = 1},
        {value = 1},
        {
            '>',
            function()
                characterSelect.selectedSprite = characterSelect.selectedSprite % 12 + 1
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    characterSelect.menu:addComponent(
        'textInput',
        {value = 2, weight = 2},
        {value = 2, weight = 1},
        {{tbl = characterSelect, key = 'nickname'}, {r = 0.3, g = 0.3, b = 0.3}}
    )
    characterSelect.menu:addComponent(
        'button',
        {value = 2, weight = 2},
        {value = 3, weight = 1},
        {
            'Back',
            function()
                return {setScene = {name = 'mainMenu', args = {characterSelect.selectedSprite, characterSelect.nickname}}}
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )

    local minDim = math.min(love.graphics.getDimensions())
    characterSelect.menu:setPadding(minDim / 40, minDim / 60)
    local border = {
        x = love.graphics.getWidth() / 4,
        y = love.graphics.getHeight() / 5
    }
    characterSelect.menu:init(border.x, border.y, love.graphics.getWidth() - border.x * 2, love.graphics.getHeight() - border.y * 2)

    function characterSelect:update()
        return self:updateMenu(self.menu, {selectedSprite = self.selectedSprite, nickname = self.nickname})
    end

    function characterSelect:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    return characterSelect
end
