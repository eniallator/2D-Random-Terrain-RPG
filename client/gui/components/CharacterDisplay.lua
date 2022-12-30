local BaseComponent = require 'client.gui.components.BaseComponent'

return function(args)
    local characterDisplay = BaseComponent(args)

    characterDisplay.imgs = {
        {
            spritesheet = ASSETS.textures.entity.player.body,
            tint = {r = 1, g = 1, b = 1}
        },
        {
            spritesheet = ASSETS.textures.entity.player.hair,
            tint = args.spriteData.hair
        },
        {
            spritesheet = ASSETS.textures.entity.player.eyes,
            tint = args.spriteData.eyes
        }
    }

    function characterDisplay:draw()
        local imgRef = self.imgs[1].spritesheet
        local quad = love.graphics.newQuad(0, 0, imgRef.width, imgRef.height, imgRef.img:getDimensions())
        local imgRatio = imgRef.width / imgRef.height
        local boxRatio = self.bakedBox.w / self.bakedBox.h
        local padding = {
            x = imgRatio < boxRatio and self.bakedBox.w - self.bakedBox.h / imgRef.height * imgRef.width or 0,
            y = imgRatio > boxRatio and self.bakedBox.h - self.bakedBox.w / imgRef.width * imgRef.height or 0
        }
        local _, data
        for _, data in ipairs(self.imgs) do
            love.graphics.setColor(data.tint.r, data.tint.g, data.tint.b, 1)
            love.graphics.draw(
                data.spritesheet.img,
                quad,
                self.bakedBox.x + padding.x / 2,
                self.bakedBox.y + padding.y / 2,
                0,
                (self.bakedBox.w - padding.x) / data.spritesheet.width,
                (self.bakedBox.h - padding.y) / data.spritesheet.height
            )
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    return characterDisplay
end
