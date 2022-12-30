return function()
    local baseGui = {}

    function baseGui:updateInputs()
        MOUSE.updateValues()
        KEYS.updateRecentPressed()
    end

    function baseGui:resize(w, h)
        self.menu:bakeStyles()
        self.menu:computeWeights()
        self.menu:bake(0, 0, w, h)
    end

    function baseGui:bake()
        self:resize(love.graphics.getDimensions())
    end

    function baseGui:update(state)
        self.menu:update(state)
        self.menu:handleClick(state)
        self:updateInputs()
    end

    function baseGui:draw()
        self.menu:draw()
    end

    return baseGui
end
