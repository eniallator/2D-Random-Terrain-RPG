local BaseComponent = require 'client.gui.components.BaseComponent'

local extraDefaultStyles = {
    colour = {r = 1, g = 1, b = 1, a = 1},
    background = {r = 0.3, g = 0.3, b = 0.3, a = 1},
    gapX = 7,
    gapY = 5,
    textBorderX = 5,
    textBorderY = 5
}

return function(args)
    local credits = BaseComponent(args, extraDefaultStyles)
    credits.data = args.data

    local oldBake = credits.bake
    function credits:bake(x, y, w, h)
        oldBake(self, x, y, w, h)

        self.bakedText = {}
        self.bakedIcons = {}

        local longestAuthor, longestCreditsType, yOffset = 0, 0, 0
        for creditsType, item in pairs(self.data) do
            table.insert(
                self.bakedText,
                {
                    ref = item,
                    {
                        text = creditsType,
                        x = self.bakedBox.x + self.bakedStyles.textBorderX,
                        y = self.bakedBox.y + self.bakedStyles.textBorderY + yOffset
                    }
                }
            )
            yOffset = yOffset + self.bakedStyles.gapY + self.bakedFont:getHeight(creditsType)

            longestAuthor = math.max(self.bakedFont:getWidth(item.author), longestAuthor)
            longestCreditsType = math.max(self.bakedFont:getWidth(creditsType), longestCreditsType)
        end

        local separator = ':'
        local xOffsets = {}
        xOffsets.separator = longestCreditsType + self.bakedStyles.gapX
        xOffsets.author = xOffsets.separator + self.bakedStyles.gapX + self.bakedFont:getWidth(separator)
        xOffsets.icon = xOffsets.author + self.bakedStyles.gapX + longestAuthor

        local _, data
        for _, data in ipairs(self.bakedText) do
            local yValue = data[1].y
            table.insert(data, {text = separator, x = self.bakedBox.x + xOffsets.separator, y = yValue})
            table.insert(data, {text = data.ref.author, x = self.bakedBox.x + xOffsets.author, y = yValue})
            local xOffset = 0
            local iconDim = self.bakedFont:getHeight(data[1].text)
            for linkType, link in pairs(data.ref.links) do
                table.insert(
                    self.bakedIcons,
                    {
                        link = link,
                        icon = ASSETS.textures.icons[linkType] or ASSETS.textures.icons.website,
                        x = self.bakedBox.x + xOffsets.icon + xOffset,
                        y = yValue,
                        dim = iconDim
                    }
                )
                xOffset = xOffset + self.bakedStyles.gapX + iconDim
            end
        end
    end

    function credits:update(state)
        if MOUSE.left.clicked then
            local _, data
            for _, data in ipairs(self.bakedIcons) do
                if
                    (data.x <= MOUSE.left.pos.x and MOUSE.left.pos.x < data.x + data.dim) and
                        (data.y <= MOUSE.left.pos.y and MOUSE.left.pos.y < data.y + data.dim)
                 then
                    love.system.openURL(data.link)
                end
            end
        end
    end

    function credits:draw()
        local background = self:getStyle('background')
        love.graphics.setColor(background.r, background.g, background.b, background.a)
        love.graphics.rectangle('fill', self.bakedBox.x, self.bakedBox.y, self.bakedBox.w, self.bakedBox.h)
        local colour = self:getStyle('colour')
        love.graphics.setColor(colour.r, colour.g, colour.b, colour.a)

        local font = love.graphics.getFont()
        love.graphics.setFont(self.bakedFont)
        local _, i, row, data
        for _, row in ipairs(self.bakedText) do
            for i = 1, #row do
                love.graphics.print(row[i].text, row[i].x, row[i].y)
            end
        end
        love.graphics.setFont(font)

        for _, data in ipairs(self.bakedIcons) do
            love.graphics.draw(
                data.icon,
                data.x,
                data.y,
                0,
                data.dim / data.icon:getWidth(),
                data.dim / data.icon:getHeight()
            )
        end
    end

    return credits
end
