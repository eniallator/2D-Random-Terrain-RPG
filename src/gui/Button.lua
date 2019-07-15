return function(box, text, onClick, colour)
    local button = {}

    button.box = box
    button.text = text
    button.onClick = onClick
    button.colour = colour or {r = 1, g = 1, b = 1}

    function button:update()
        if
            MOUSE.left.clicked and (self.box.x <= MOUSE.left.pos.x and MOUSE.left.pos.x < self.box.x + self.box.width) and
                (self.box.y <= MOUSE.left.pos.y and MOUSE.left.pos.y < self.box.y + self.box.height)
         then
            return self.onClick()
        end
    end

    function button:draw()
        local font = love.graphics.getFont()

        love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b)
        love.graphics.rectangle('fill', self.box.x, self.box.y, self.box.width, self.box.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(
            self.text,
            self.box.x + self.box.width / 2 - font:getWidth(self.text) / 2,
            self.box.y + self.box.height / 2 - font:getHeight(self.text) / 2
        )
    end

    return button
end
