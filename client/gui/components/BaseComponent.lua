local defaultStyles = {
    marginLeft = 0,
    marginTop = 0,
    marginRight = 0,
    marginBottom = 0,
    background = {r = 0, g = 0, b = 0, a = 1}
}

return function(args, extraDefaultStyles)
    local baseComponent = {}

    baseComponent.disabled = args.disabled
    baseComponent.children = args.children
    baseComponent.xWeight = math.max(1, args.xWeight or 1)
    baseComponent.yWeight = math.max(1, args.yWeight or 1)
    baseComponent.styles = args.styles or {}

    function baseComponent:getPixels(val, maxDim)
        if type(val) == 'number' then
            return val
        else
            local percent = val:match('([^%%]+)%%')
            return tonumber(percent) / 100 * maxDim
        end
    end

    function baseComponent:bakeStyles()
        self.bakedStyles = {}

        local key, val, _, child
        for key, val in pairs(self.styles) do
            self.bakedStyles[key] = val
        end

        for key, val in pairs(defaultStyles) do
            if type(self.styles[key]) == 'nil' then
                self.bakedStyles[key] = val
            end
        end

        if extraDefaultStyles then
            for key, val in pairs(extraDefaultStyles) do
                if type(self.styles[key]) == 'nil' then
                    self.bakedStyles[key] = val
                end
            end
        end

        if self.children then
            for _, child in ipairs(self.children) do
                child:bakeStyles()
            end
        end
    end

    function baseComponent:computeWeights()
        local totalChildYWeight = 0
        if self.children then
            local _, child
            for _, child in pairs(self.children) do
                child:computeWeights()
                totalChildYWeight = totalChildYWeight + child.computedYWeight
            end
        end
        self.computedXWeight = self.xWeight or 1
        self.computedYWeight = self.yWeight or math.max(1, totalChildYWeight)
    end

    function baseComponent:bakeChildren(x, y, w, h)
        error('Must implement a bakeChildren method for components with children')
    end

    function baseComponent:bake(x, y, w, h)
        local xOffset = self:getPixels(self.bakedStyles.marginLeft, w)
        local yOffset = self:getPixels(self.bakedStyles.marginTop, h)
        self.bakedBox = {
            x = x + xOffset,
            y = y + yOffset,
            w = w - xOffset - self:getPixels(self.bakedStyles.marginRight, w),
            h = h - yOffset - self:getPixels(self.bakedStyles.marginBottom, h)
        }
        if self.children then
            self:bakeChildren(self.bakedBox.x, self.bakedBox.y, self.bakedBox.w, self.bakedBox.h)
        end
    end

    function baseComponent:handleClick(state)
        local clickedInside =
            MOUSE.left.clicked and
            (self.bakedBox.x <= MOUSE.left.pos.x and MOUSE.left.pos.x < self.bakedBox.x + self.bakedBox.w) and
            (self.bakedBox.y <= MOUSE.left.pos.y and MOUSE.left.pos.y < self.bakedBox.y + self.bakedBox.h)
        if clickedInside and (self.disabled == nil or not self.disabled(state)) then
            local clickHandled = false
            if self.children then
                local _, child
                for _, child in pairs(self.children) do
                    clickHandled = child:handleClick(state)
                    if clickHandled then
                        break
                    end
                end
            end
            if not clickHandled and self.onClick then
                self.onClick(state)
            end
        end
        return clickedInside
    end

    function baseComponent:update(state)
        if self.children then
            local _, child
            for _, child in ipairs(self.children) do
                child:update(state)
            end
        end
    end

    function baseComponent:draw()
        if self.bakedBox == nil then
            error('Component must be baked first before drawing')
        end
        local font = love.graphics.getFont()

        love.graphics.setColor(
            self.bakedStyles.background.r,
            self.bakedStyles.background.g,
            self.bakedStyles.background.b,
            self.bakedStyles.background.a
        )
        love.graphics.rectangle('fill', self.bakedBox.x, self.bakedBox.y, self.bakedBox.w, self.bakedBox.h)

        if self.children then
            local _, child
            for _, child in ipairs(self.children) do
                child:draw()
            end
        end
    end

    return baseComponent
end
