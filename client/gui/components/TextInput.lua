local BaseComponent = require 'client.gui.components.BaseComponent'

local extraDefaultStyles = {
    colour = {r = 1, g = 1, b = 1, a = 1},
    background = {r = 0.3, g = 0.3, b = 0.3, a = 1},
    selectedBackground = {r = 0.4, g = 0.4, b = 0.4, a = 1}
}

return function(args)
    local textInput = BaseComponent(args, extraDefaultStyles)

    textInput.outputTbl = args.outputTbl
    textInput.outputTblKey = args.outputTblKey
    textInput.selected = false
    textInput.previousState = false

    function textInput:update(state)
        if MOUSE.left.clicked then
            self.selected =
                (self.bakedBox.x <= MOUSE.left.pos.x and MOUSE.left.pos.x < self.bakedBox.x + self.bakedBox.w) and
                (self.bakedBox.y <= MOUSE.left.pos.y and MOUSE.left.pos.y < self.bakedBox.y + self.bakedBox.h)
        end

        if self.selected then
            if not self.previousState then
                KEYS.textString = self.outputTbl[self.outputTblKey] or ''
            end
            self.outputTbl[self.outputTblKey] = KEYS.textString
        end
        self.previousState = self.selected
    end

    function textInput:draw()
        local text = self.outputTbl[self.outputTblKey] or ''
        local font = love.graphics.getFont()

        local background = self.selected and self.bakedStyles.selectedBackground or self.bakedStyles.background

        love.graphics.setColor(background.r, background.g, background.b, background.a)
        love.graphics.rectangle('fill', self.bakedBox.x, self.bakedBox.y, self.bakedBox.w, self.bakedBox.h)
        love.graphics.setColor(
            self.bakedStyles.colour.r,
            self.bakedStyles.colour.g,
            self.bakedStyles.colour.b,
            self.bakedStyles.colour.a
        )
        love.graphics.print(
            text,
            self.bakedBox.x + self.bakedBox.w / 2 - font:getWidth(text) / 2,
            self.bakedBox.y + self.bakedBox.h / 2 - font:getHeight(text) / 2
        )
    end

    return textInput
end
