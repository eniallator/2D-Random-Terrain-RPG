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
        local font = love.graphics.getFont()
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
            yOffset = yOffset + self.bakedStyles.gapY + font:getHeight(creditsType)

            longestAuthor = math.max(font:getWidth(item.author or ''), longestAuthor)
            longestCreditsType = math.max(font:getWidth(creditsType), longestCreditsType)
        end

        local seperator = ':'
        local xOffsets = {}
        xOffsets.seperator = longestCreditsType + self.bakedStyles.gapX
        xOffsets.author = xOffsets.seperator + self.bakedStyles.gapX + font:getWidth(seperator)
        xOffsets.icon = xOffsets.author + self.bakedStyles.gapX + longestAuthor

        local _, data
        for _, data in ipairs(self.bakedText) do
            local yValue = data[1].y
            table.insert(data, {text = seperator, x = xOffsets.seperator, y = yValue})
            table.insert(data, {text = data.ref.author, x = xOffsets.author, y = yValue})
            local xOffset = 0
            local iconDim = font:getHeight(data[1].text)
            for linkType, link in pairs(data.ref.links) do
                table.insert(
                    self.bakedIcons,
                    {
                        link = link,
                        icon = ASSETS.textures.icons[linkType] or ASSETS.textures.icons.website,
                        x = self.bakedBox.x + xOffsets.icon + xOffset,
                        y = self.bakedBox.y + yValue,
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
                    (self.bakedBox.x + data.x <= MOUSE.left.pos.x and
                        MOUSE.left.pos.x < self.bakedBox.x + data.x + data.dim) and
                        (self.bakedBox.y + data.y <= MOUSE.left.pos.y and
                            MOUSE.left.pos.y < self.bakedBox.y + data.y + data.dim)
                 then
                    love.system.openURL(data.link)
                end
            end
        end
    end

    function credits:draw()
        love.graphics.setColor(
            self.bakedStyles.background.r,
            self.bakedStyles.background.g,
            self.bakedStyles.background.b,
            self.bakedStyles.background.a
        )
        love.graphics.rectangle('fill', self.bakedBox.x, self.bakedBox.y, self.bakedBox.w, self.bakedBox.h)
        love.graphics.setColor(
            self.bakedStyles.colour.r,
            self.bakedStyles.colour.g,
            self.bakedStyles.colour.b,
            self.bakedStyles.colour.a
        )

        local _, i, row, data
        for _, row in ipairs(self.bakedText) do
            for i = 1, #row do
                love.graphics.print(row[i].text, row[i].x, row[i].y)
            end
        end

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
