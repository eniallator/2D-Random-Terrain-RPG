local BaseComponent = require 'client.gui.components.BaseComponent'

local extraDefaultStyles = {
    colour = {r = 1, g = 1, b = 1, a = 1},
    background = {r = 0.5, g = 0.5, b = 0.5, a = 1}
}

return function(args)
    local label = BaseComponent(args, extraDefaultStyles)

    if type(args.text) == 'function' then
        label.textFunc = args.text
        label.text = ''

        function label:update(state)
            self.text = self.textFunc(state) or ''
        end
    else
        label.text = args.text or ''
    end

    local oldDraw = label.draw
    function label:draw()
        oldDraw(self)
        local font = love.graphics.getFont()
        love.graphics.setColor(
            self.bakedStyles.colour.r,
            self.bakedStyles.colour.g,
            self.bakedStyles.colour.b,
            self.bakedStyles.colour.a
        )
        love.graphics.print(
            self.text,
            self.bakedBox.x + self.bakedBox.w / 2 - font:getWidth(self.text) / 2,
            self.bakedBox.y + self.bakedBox.h / 2 - font:getHeight(self.text) / 2
        )
    end

    return label
end
