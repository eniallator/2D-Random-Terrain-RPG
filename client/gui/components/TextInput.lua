local BaseComponent = require 'client.gui.components.BaseComponent'

local extraDefaultStyles = {
    colour = {r = 1, g = 1, b = 1, a = 1},
    background = {r = 0.3, g = 0.3, b = 0.3, a = 1},
    _selected = {background = {r = 0.4, g = 0.4, b = 0.4, a = 1}}
}

return function(args)
    local textInput = BaseComponent(args, extraDefaultStyles)

    textInput.outputTbl = args.outputTbl
    textInput.outputTblKey = args.outputTblKey
    textInput.isSelected = false
    textInput.previousState = false

    function textInput:update(state)
        if MOUSE.left.clicked then
            self.isSelected =
                (self.bakedBox.x <= MOUSE.left.pos.x and MOUSE.left.pos.x < self.bakedBox.x + self.bakedBox.w) and
                (self.bakedBox.y <= MOUSE.left.pos.y and MOUSE.left.pos.y < self.bakedBox.y + self.bakedBox.h)
        end

        if self.isSelected then
            if not self.previousState then
                KEYS.textString = self.outputTbl[self.outputTblKey] or ''
            end
            self.outputTbl[self.outputTblKey] = KEYS.textString
        end
        self.previousState = self.isSelected
    end

    local oldGetStyle = textInput.getStyle
    function textInput:getStyle(style)
        return self.isSelected and self.bakedStyles._selected[style] or oldGetStyle(self, style)
    end

    function textInput:draw()
        local background = self:getStyle('background')
        love.graphics.setColor(background.r, background.g, background.b, background.a)
        love.graphics.rectangle('fill', self.bakedBox.x, self.bakedBox.y, self.bakedBox.w, self.bakedBox.h)

        local text = self.outputTbl[self.outputTblKey] or ''
        local font = love.graphics.getFont()

        local colour = self:getStyle('colour')
        love.graphics.setColor(colour.r, colour.g, colour.b, colour.a)
        love.graphics.setFont(self.bakedFont)
        love.graphics.print(
            text,
            self.bakedBox.x + self.bakedBox.w / 2 - self.bakedFont:getWidth(text) / 2,
            self.bakedBox.y + self.bakedBox.h / 2 - self.bakedFont:getHeight(text) / 2
        )
        love.graphics.setFont(font)
    end

    return textInput
end
