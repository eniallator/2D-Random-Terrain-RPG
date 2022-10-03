local Sprite = require 'client.Sprite'

return function(spriteWidth, spriteHeight)
    local layeredSprite = Sprite(spriteWidth, spriteHeight)

    function layeredSprite:addAnimation(name, spritesheetData, frameRegions, repeating)
        self.animations[name] = {
            spritesheetData = spritesheetData,
            frameRegions = frameRegions,
            repeating = repeating,
            quads = {}
        }
        for i = 1, #frameRegions do
            local region = frameRegions[i]
            table.insert(
                self.animations[name].quads,
                love.graphics.newQuad(
                    region.x,
                    region.y,
                    region.width,
                    region.height,
                    spritesheetData.width,
                    spritesheetData.height
                )
            )
        end
    end

    function layeredSprite:draw(pos, box)
        if self.playingAnimation == nil then
            self.playingAnimation = self.defaultAnimation
        end

        local animation = self.animations[self.playingAnimation]
        local region = animation.frameRegions[self.frameIndex]
        local scale = {
            x = self.dim.width * love.graphics.getWidth() / box.width / region.width,
            y = self.dim.height * love.graphics.getHeight() / box.height / region.height
        }
        local inversionOffset = {
            x = region.invertX and scale.x * region.width or 0,
            y = region.invertY and scale.y * region.height or 0
        }
        local drawPos = {
            x = (pos.x - box.x + box.width / 2) / box.width * love.graphics.getWidth() - region.width * scale.x / 2,
            y = (pos.y - box.y + box.height / 2) / box.height * love.graphics.getHeight() - region.height * scale.y
        }

        for _, spritesheetData in ipairs(animation.spritesheetData) do
            love.graphics.setColor(
                spritesheetData.tint.r,
                spritesheetData.tint.g,
                spritesheetData.tint.b,
                spritesheetData.tint.a or 1
            )
            love.graphics.draw(
                spritesheetData.spritesheet.img,
                animation.quads[self.frameIndex],
                drawPos.x + inversionOffset.x,
                drawPos.y + inversionOffset.y,
                region.rotation or 0,
                scale.x * (region.invertX and -1 or 1),
                scale.y * (region.invertY and -1 or 1)
            )
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    return layeredSprite
end
