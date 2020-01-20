local BaseGui = require 'src.gui.BaseGui'
local Grid = require 'src.gui.Grid'
local ClassLookup = require 'src.class.ClassLookup'

return function(spriteData, nickname, selectedClass, key, colour)
    local characterSelect = BaseGui()

    characterSelect.spriteData = spriteData
    if key and colour then
        characterSelect.spriteData[key] = colour
    end

    characterSelect.nickname = nickname or 'default'
    characterSelect.selectedClass = selectedClass

    local selectedClassReference = {'No class selected'}
    if characterSelect.selectedClass ~= nil then
        selectedClassReference[1] = ClassLookup[characterSelect.selectedClass].name
    end

    characterSelect.menu = Grid()
    characterSelect.menu:addComponent(
        'textInput',
        {value = 2, weight = 2},
        {value = 1, weight = 1},
        {{tbl = characterSelect, key = 'nickname'}, {r = 0.3, g = 0.3, b = 0.3}}
    )
    characterSelect.menu:addComponent(
        'button',
        {value = 1, weight = 1},
        {value = 2, weight = 4},
        {
            'Eye Colour',
            function()
                return {
                    setScene = {
                        name = 'colourPicker',
                        args = {characterSelect.spriteData, characterSelect.nickname, characterSelect.selectedClass, 'eyes', 'Eye Colour', characterSelect.spriteData.eyes}
                    }
                }
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    characterSelect.menu:addComponent('characterDisplay', {value = 2}, {value = 2}, {characterSelect.spriteData})
    characterSelect.menu:addComponent(
        'button',
        {value = 3, weight = 1},
        {value = 2},
        {
            'Hair Colour',
            function()
                return {
                    setScene = {
                        name = 'colourPicker',
                        args = {characterSelect.spriteData, characterSelect.nickname, characterSelect.selectedClass, 'hair', 'Hair Colour', characterSelect.spriteData.hair}
                    }
                }
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    characterSelect.menu:addComponent(
        'button',
        {value = 1, weight = 1},
        {value = 3, weight = 1},
        {
            '<',
            function()
                if characterSelect.selectedClass == nil then
                    characterSelect.selectedClass = #ClassLookup
                else
                    characterSelect.selectedClass = (characterSelect.selectedClass - 2) % #ClassLookup + 1
                end
                selectedClassReference[1] = ClassLookup[characterSelect.selectedClass].name
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    characterSelect.menu:addComponent('label', {value = 2}, {value = 3}, {selectedClassReference})
    characterSelect.menu:addComponent(
        'button',
        {value = 3, weight = 1},
        {value = 3},
        {
            '>',
            function()
                if characterSelect.selectedClass == nil then
                    characterSelect.selectedClass = 1
                else
                    characterSelect.selectedClass = characterSelect.selectedClass % #ClassLookup + 1
                end
                selectedClassReference[1] = ClassLookup[characterSelect.selectedClass].name
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    characterSelect.menu:addComponent(
        'button',
        {value = 2, weight = 2},
        {value = 4, weight = 1},
        {
            'Back',
            function()
                return {
                    setScene = {
                        name = 'mainMenu',
                        args = {characterSelect.spriteData, characterSelect.nickname, characterSelect.selectedClass}
                    }
                }
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )

    function characterSelect:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 40, minDim / 60)
        local border = {
            x = width / 4,
            y = height / 5
        }
        self.menu:init(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function characterSelect:update()
        return self:updateMenu(self.menu, {spriteData = self.spriteData, nickname = self.nickname})
    end

    function characterSelect:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    characterSelect:resize(love.graphics.getDimensions())

    return characterSelect
end
