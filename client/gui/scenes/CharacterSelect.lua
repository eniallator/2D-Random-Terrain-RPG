local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.Grid'
local classLookup = require 'client.class.ClassLookup'

return function(state)
    local characterSelect = BaseGui()

    characterSelect.menu = Grid()
    characterSelect.menu:addComponent(
        'textInput',
        {value = 2, weight = 2},
        {value = 1, weight = 1},
        {{tbl = state, key = 'nickname'}, {r = 0.3, g = 0.3, b = 0.3}}
    )
    characterSelect.menu:addComponent(
        'button',
        {value = 1, weight = 1},
        {value = 2, weight = 4},
        {
            'Eye Colour',
            function(state)
                state.scene = 'colourPicker'
                state.selectedColourLabel = 'Eye Colour'
                state.selectedColourTbl = state.spriteData.eyes
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    characterSelect.menu:addComponent('characterDisplay', {value = 2}, {value = 2}, {state.spriteData})
    characterSelect.menu:addComponent(
        'button',
        {value = 3, weight = 1},
        {value = 2},
        {
            'Hair Colour',
            function(state)
                state.scene = 'colourPicker'
                state.selectedColourLabel = 'Hair Colour'
                state.selectedColourTbl = state.spriteData.hair
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
            function(state)
                local index
                if state.class == nil then
                    index = #classLookup
                else
                    index = (classLookup.indices[state.class] - 2) % #classLookup + 1
                end
                state.class = classLookup[index].name
            end,
            {r = 0, g = 0.7, b = 0}
        }
    )
    characterSelect.menu:addComponent(
        'label',
        {value = 2},
        {value = 3},
        {
            function(state)
                return state.class or 'No class selected'
            end
        }
    )
    characterSelect.menu:addComponent(
        'button',
        {value = 3, weight = 1},
        {value = 3},
        {
            '>',
            function()
                local index
                if characterSelect.selectedClass == nil then
                    index = 1
                else
                    index = classLookup.indices[state.class] % #classLookup + 1
                end
                state.class = classLookup[index].name
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
            function(state)
                state.scene = 'mainMenu'
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
        self.menu:bakeComponents(border.x, border.y, width - border.x * 2, height - border.y * 2)
    end

    function characterSelect:update()
        self:updateMenu(self.menu, state)
    end

    function characterSelect:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    characterSelect:resize(love.graphics.getDimensions())

    return characterSelect
end
