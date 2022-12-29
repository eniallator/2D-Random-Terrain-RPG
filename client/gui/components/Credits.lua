return function(box, data, bgColour, textColour)
    local credits = {}
    local textBorder = {x = 5, y = 5}
    local ySpacing = 5
    local xSpacing = 7

    credits.box = box
    credits.data = data
    credits.bgColour = bgColour or {r = 0.5, g = 0.5, b = 0.5, a = 1}
    credits.textColour = textColour or {r = 1, g = 1, b = 1}

    credits.textData = {}
    credits.iconData = {}

    local longestAuthor, longestCreditsType, yOffset = 0, 0, 0
    local font = love.graphics.getFont()
    for creditsType, item in pairs(credits.data) do
        table.insert(
            credits.textData,
            {reference = item, {text = creditsType, x = textBorder.x, y = textBorder.y + yOffset}}
        )
        yOffset = yOffset + ySpacing + font:getHeight(creditsType)

        if item.author and font:getWidth(item.author) > longestAuthor then
            longestAuthor = font:getWidth(item.author)
        end
        if font:getWidth(creditsType) > longestCreditsType then
            longestCreditsType = font:getWidth(creditsType)
        end
    end

    local seperator = ':'
    local xOffsets = {}
    xOffsets.seperator = longestCreditsType + xSpacing
    xOffsets.author = xOffsets.seperator + xSpacing + font:getWidth(seperator)
    xOffsets.icon = xOffsets.author + xSpacing + longestAuthor

    local _, data
    for _, data in ipairs(credits.textData) do
        local yValue = data[1].y
        table.insert(data, {text = seperator, x = xOffsets.seperator, y = yValue})
        table.insert(data, {text = data.reference.author, x = xOffsets.author, y = yValue})
        local xOffset = 0
        local iconDim = font:getHeight(data[1].text)
        for linkType, link in pairs(data.reference.links) do
            table.insert(
                credits.iconData,
                {
                    link = link,
                    icon = ASSETS.textures.icons[linkType],
                    x = xOffsets.icon + xOffset,
                    y = yValue,
                    dim = iconDim
                }
            )
            xOffset = xOffset + xSpacing + iconDim
        end
    end

    function credits:update(state)
        if MOUSE.left.clicked then
            local _, data
            for _, data in ipairs(self.iconData) do
                if
                    (self.box.x + data.x <= MOUSE.left.pos.x and MOUSE.left.pos.x < self.box.x + data.x + data.dim) and
                        (self.box.y + data.y <= MOUSE.left.pos.y and MOUSE.left.pos.y < self.box.y + data.y + data.dim)
                 then
                    love.system.openURL(data.link)
                end
            end
        end
    end

    function credits:draw()
        love.graphics.setColor(self.bgColour.r, self.bgColour.g, self.bgColour.b, self.bgColour.a)
        love.graphics.rectangle('fill', self.box.x, self.box.y, self.box.width, self.box.height)
        love.graphics.setColor(self.textColour.r, self.textColour.g, self.textColour.b)

        local _, i, row, data
        for _, row in ipairs(self.textData) do
            for i = 1, #row do
                love.graphics.print(row[i].text, self.box.x + row[i].x, self.box.y + row[i].y)
            end
        end

        for _, data in ipairs(self.iconData) do
            love.graphics.draw(
                data.icon,
                self.box.x + data.x,
                self.box.y + data.y,
                0,
                data.dim / data.icon:getWidth(),
                data.dim / data.icon:getHeight()
            )
        end
    end

    return credits
end
