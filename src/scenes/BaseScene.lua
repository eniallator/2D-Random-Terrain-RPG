return function()
    local baseScene = {}

    function baseScene:updateMenu(menu, state)
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

    function baseScene:drawMenu(menu, dt)
        for _, component in ipairs(menu:getComponents()) do
            if type(component.draw) == 'function' then
                component:draw(dt)
            end
        end
    end

    function baseScene:update()
        error('Scene has not implemented update function yet!')
    end

    function baseScene:draw(dt)
        error('Scene has not implemented draw function yet!')
    end

    return baseScene
end
