return function(box, spriteData)
    local characterDisplay = {}

    -- print(serialise(spriteData))

    characterDisplay.imgs = {
        {
            spritesheet = ASSETS.textures.entity.player.body,
            tint = {r = 1, g = 1, b = 1}
        },
        {
            spritesheet = ASSETS.textures.entity.player.hair,
            tint = spriteData.hair
        },
        {
            spritesheet = ASSETS.textures.entity.player.eyes,
            tint = spriteData.eyes
        }
    }

    characterDisplay.box = box
    characterDisplay.spriteData = spriteData

    function characterDisplay:draw()
        local imgRef = self.imgs[1].spritesheet
        local quad =
            love.graphics.newQuad(
            0,
            0,
            imgRef.width,
            imgRef.height,
            imgRef.img:getDimensions()
        )
        local imgRatio = imgRef.width / imgRef.height
        local boxRatio = self.box.width / self.box.height
        local padding = {
            x = 0,
            y = 0
        }
        if imgRatio > boxRatio then
            padding.y = self.box.height - self.box.width / imgRef.width * imgRef.height
        elseif imgRatio < boxRatio then
            padding.x = self.box.width - self.box.height / imgRef.height * imgRef.width
        end
        for _, data in ipairs(self.imgs) do
            love.graphics.setColor(data.tint.r, data.tint.g, data.tint.b, 1)
            love.graphics.draw(
                data.spritesheet.img,
                quad,
                self.box.x + padding.x / 2,
                self.box.y + padding.y / 2,
                0,
                (self.box.width - padding.x) / data.spritesheet.width,
                (self.box.height - padding.y) / data.spritesheet.height
            )
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    return characterDisplay
end
