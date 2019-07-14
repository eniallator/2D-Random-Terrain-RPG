return function()
    local scene = {}

    function scene:update()
        error('Scene has not implemented update function yet!')
    end

    function scene:draw(dt)
        error('Scene has not implemented draw function yet!')
    end

    return scene
end
