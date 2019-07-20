return function()
    local baseGui = {}

    function baseGui:updateMenu(menu, state)
        local returnData = {}
        for _, component in ipairs(menu:getComponents()) do
            if type(component.update) == 'function' then
                local data = component:update(state)
                if data ~= nil then
                    table.insert(returnData, data)
                end
            end
        end
        return #returnData > 0 and returnData or nil
    end

    function baseGui:drawMenu(menu, dt)
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
