local defaultStyles = {
    marginLeft = 0,
    marginTop = 0,
    marginRight = 0,
    marginBottom = 0,
    background = {r = 0, g = 0, b = 0, a = 1},
    colour = {r = 1, g = 1, b = 1, a = 1},
    _disabled = {},
    font = nil,
    fontSize = '4vmin'
}

local unitConversion = {
    ['%'] = function(value, ctx)
        return value / 100 * ctx.containerAxisMax
    end,
    vw = function(value, ctx)
        return value / 100 * ctx.viewport.w
    end,
    vh = function(value, ctx)
        return value / 100 * ctx.viewport.h
    end,
    vmin = function(value, ctx)
        return value / 100 * math.min(ctx.viewport.w, ctx.viewport.h)
    end,
    vmax = function(value, ctx)
        return value / 100 * math.max(ctx.viewport.w, ctx.viewport.h)
    end
}

return function(args, extraDefaultStyles)
    local baseComponent = {}

    baseComponent.disabled = args.disabled
    baseComponent.children = args.children
    baseComponent.xWeight = math.max(1, args.xWeight or 1)
    baseComponent.yWeight = math.max(1, args.yWeight or 1)
    baseComponent.styles = args.styles or {}

    if type(args.text) == 'function' then
        baseComponent.textFunc = args.text
        baseComponent.text = ''
    else
        baseComponent.text = args.text or ''
    end

    function baseComponent:getPixels(val, containerAxisMax)
        local valType = type(val)
        if valType == 'number' then
            return val
        elseif valType == 'string' then
            local ctx = {
                containerAxisMax = containerAxisMax,
                viewport = {}
            }
            ctx.viewport.w, ctx.viewport.h = love.graphics.getDimensions()

            local value, units = val:match('^([%d%.]+)([%w%%]+)$')
            return unitConversion[units] and unitConversion[units](tonumber(value), ctx) or nil
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
        local fontSize = self:getPixels(self.bakedStyles.fontSize, math.min(w, h))
        self.bakedFont =
            self.bakedStyles.font and love.graphics.newFont(ASSETS.fonts[self.bakedStyles.font], fontSize) or
            love.graphics.newFont(fontSize)
        if self.children then
            self:bakeChildren(self.bakedBox.x, self.bakedBox.y, self.bakedBox.w, self.bakedBox.h)
        end
    end

    function baseComponent:update(state)
        if self.textFunc then
            self.text = self.textFunc(state) or ''
        end
        self.isDisabled = self.disabled ~= nil and self.disabled(state)
        if self.children then
            local _, child
            for _, child in ipairs(self.children) do
                child:update(state)
            end
        end
    end

    function baseComponent:handleClick(state)
        local clickedInside =
            MOUSE.left.clicked and
            (self.bakedBox.x <= MOUSE.left.pos.x and MOUSE.left.pos.x < self.bakedBox.x + self.bakedBox.w) and
            (self.bakedBox.y <= MOUSE.left.pos.y and MOUSE.left.pos.y < self.bakedBox.y + self.bakedBox.h)
        if clickedInside and not self.isDisabled then
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

    function baseComponent:getStyle(style)
        return self.isDisabled and self.bakedStyles._disabled[style] or self.bakedStyles[style]
    end

    function baseComponent:draw()
        if self.bakedBox == nil then
            error('Component must be baked first before drawing')
        end
        local font = love.graphics.getFont()

        local background = self:getStyle('background')
        love.graphics.setColor(background.r, background.g, background.b, background.a)
        love.graphics.rectangle('fill', self.bakedBox.x, self.bakedBox.y, self.bakedBox.w, self.bakedBox.h)

        local colour = self:getStyle('colour')
        love.graphics.setColor(colour.r, colour.g, colour.b, colour.a)
        local font = love.graphics.getFont()
        local _, lines = self.bakedFont:getWrap(self.text, self.bakedBox.w)
        love.graphics.setFont(self.bakedFont)
        love.graphics.printf(
            self.text,
            self.bakedBox.x,
            self.bakedBox.y + self.bakedBox.h / 2 - #lines * self.bakedFont:getHeight(self.text) / 2,
            self.bakedBox.w,
            'center'
        )
        love.graphics.setFont(font)

        if self.children then
            local _, child
            for _, child in ipairs(self.children) do
                child:draw()
            end
        end
    end

    return baseComponent
end
