return function(box, text, onClick, bgColour, textColour, disabled)
    local button = {}

    button.box = box
    button.text = text
    button.onClick = onClick
    button.bgColour = bgColour or {r = 0.5, g = 0.5, b = 0.5}
    button.textColour = textColour or {r = 1, g = 1, b = 1}
    button.disabled = disabled

    function button:update(state)
        if
            (self.disabled == nil or not self.disabled(state)) and MOUSE.left.clicked and
                (self.box.x <= MOUSE.left.pos.x and MOUSE.left.pos.x < self.box.x + self.box.width) and
                (self.box.y <= MOUSE.left.pos.y and MOUSE.left.pos.y < self.box.y + self.box.height)
         then
            return self.onClick(state)
        end
    end

    function button:draw()
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

    return button
end
