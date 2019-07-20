return function(box, text, bgColour, textColour)
    local label = {}

    label.box = box
    label.text = text or ''
    label.bgColour = bgColour or {r = 0.5, g = 0.5, b = 0.5}
    label.textColour = textColour or {r = 1, g = 1, b = 1}

    function label:draw()
        local font = love.graphics.getFont()

        love.graphics.setColor(self.bgColour.r, self.bgColour.g, self.bgColour.b)
        love.graphics.rectangle('fill', self.box.x, self.box.y, self.box.width, self.box.height)
        love.graphics.setColor(self.textColour.r, self.textColour.g, self.textColour.b)
        love.graphics.print(
            self.text,
            self.box.x + self.box.width / 2 - font:getWidth(self.text) / 2,
            self.box.y + self.box.height / 2 - font:getHeight(self.text) / 2
        )
    end

    return label
end
