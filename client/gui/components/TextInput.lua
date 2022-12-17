return function(box, textLocation, bgColour, selectedBgColour, textColour)
    local textInput = {}

    textInput.box = box
    textInput.location = textLocation.tbl
    textInput.locationKey = textLocation.key
    textInput.bgColour = bgColour
    textInput.selectedBgColour =
        selectedBgColour or
        {
            r = math.min(textInput.bgColour.r + 0.1, 1),
            g = math.min(textInput.bgColour.g + 0.1, 1),
            b = math.min(textInput.bgColour.b + 0.1, 1)
        }
    textInput.textColour = textColour or {r = 1, g = 1, b = 1}
    textInput.selected = false
    textInput.previousState = false

    function textInput:update()
        if MOUSE.left.clicked then
            self.selected =
                (self.box.x <= MOUSE.left.pos.x and MOUSE.left.pos.x < self.box.x + self.box.width) and
                (self.box.y <= MOUSE.left.pos.y and MOUSE.left.pos.y < self.box.y + self.box.height)
        end

        if self.selected then
            if not self.previousState then
                KEYS.textString = self.location[self.locationKey] or ''
            end
            self.location[self.locationKey] = KEYS.textString
        end
        self.previousState = self.selected
    end

    function textInput:draw()
        local text = self.location[self.locationKey] or ''
        local font = love.graphics.getFont()

        local bgColour = self.selected and self.selectedBgColour or self.bgColour

        love.graphics.setColor(bgColour.r, bgColour.g, bgColour.b)
        love.graphics.rectangle('fill', self.box.x, self.box.y, self.box.width, self.box.height)
        love.graphics.setColor(self.textColour.r, self.textColour.g, self.textColour.b)
        love.graphics.print(
            text,
            self.box.x + self.box.width / 2 - font:getWidth(text) / 2,
            self.box.y + self.box.height / 2 - font:getHeight(text) / 2
        )
    end

    return textInput
end
