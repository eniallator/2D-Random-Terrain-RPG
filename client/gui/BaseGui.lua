return function()
    local baseGui = {}

    function baseGui:updateInputs()
        MOUSE.updateValues()
        KEYS.updateRecentPressed()
    end

    function baseGui:updateMenu(menu, state)
        local _, component
        for _, component in ipairs(menu:getComponents()) do
            if type(component.update) == 'function' then
                component:update(state)
            end
        end
        self:updateInputs()
    end

    function baseGui:drawMenu(menu, dt)
        local _, component
        for _, component in ipairs(menu:getComponents()) do
            if type(component.draw) == 'function' then
                component:draw(dt)
            end
        end
    end

    function baseGui:update()
        error('Gui has not implemented update function yet!')
    end

    function baseGui:draw(dt)
        error('Gui has not implemented draw function yet!')
    end

    return baseGui
end
