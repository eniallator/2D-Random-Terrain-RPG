return function(spriteWidth, spriteHeight)
    local sprite = {}

    sprite.dim = {
        width = spriteWidth,
        height = spriteHeight or spriteWidth
    }

    sprite.animations = {}
    sprite.defaultAnimation = nil
    sprite.playingAnimation = nil
    sprite.frameIndex = 1

    function sprite:addAnimation(name, spritesheet, frameRegions, repeating)
        self.animations[name] = {
            spritesheet = spritesheet,
            frameRegions = frameRegions,
            repeating = repeating
        }
    end

    function sprite:setDefaultAnimation(name)
        self.defaultAnimation = name
    end

    function sprite:playAnimation(name)
        self.playingAnimation = self.animations[name] and name or self.defaultAnimation
        self.frameIndex = 1
    end

    function sprite:advanceAnimation(numFrames)
        self.frameIndex = self.frameIndex + numFrames
        local animation = self.animations[self.playingAnimation]

        if self.frameIndex > #animation.frameRegions then
            if type(animation.repeating) == 'nil' or animation.repeating then
                self.frameIndex = ((self.frameIndex - 1) % #animation.frameRegions) + 1
            elseif self.defaultAnimation ~= nil then
                self.playingAnimation = self.defaultAnimation
            end
        end
    end

    function sprite:drawShadow(pos, box)
        local spriteDim = {
            width = self.dim.width * love.graphics.getWidth() / box.width,
            height = self.dim.height * love.graphics.getHeight() / box.height
        }
        local drawPos = {
            x = (pos.x - box.x + box.width / 2) / box.width * love.graphics.getWidth() - spriteDim.width / 2,
            y = (pos.y - box.y + box.height / 2) / box.height * love.graphics.getHeight() - spriteDim.height / 2
        }
        local radius = spriteDim.width / 2.5
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.ellipse('fill', drawPos.x + spriteDim.width / 2, drawPos.y + spriteDim.height, radius, radius / 1.5)
        love.graphics.setColor(1, 1, 1, 1)
    end

    function sprite:draw(pos, box)
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
            y = (pos.y - box.y + box.height / 2) / box.height * love.graphics.getHeight() - region.height * scale.y / 2
        }

        local quad =
            love.graphics.newQuad(
            region.x,
            region.y,
            region.width,
            region.height,
            animation.spritesheet:getWidth(),
            animation.spritesheet:getHeight()
        )
        love.graphics.draw(
            animation.spritesheet,
            quad,
            drawPos.x + inversionOffset.x,
            drawPos.y + inversionOffset.y,
            region.rotation or 0,
            scale.x * (region.invertX and -1 or 1),
            scale.y * (region.invertY and -1 or 1)
        )
    end

    return sprite
end
