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
            name = name,
            spritesheet = spritesheet,
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
                    spritesheet:getWidth(),
                    spritesheet:getHeight()
                )
            )
        end
    end

    function sprite:setDefaultAnimation(name)
        self.defaultAnimation = name
    end

    function sprite:playAnimation(name, force)
        local nextAnimation = name or self.defaultAnimation
        if force or self.playingAnimation == nil or nextAnimation ~= self.playingAnimation then
            self.playingAnimation = self.animations[name] and name or self.defaultAnimation
            self.frameIndex = 1
        end
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

    function sprite:getFrameBox(pos, box)
        local spriteDim = {
            width = self.dim.width * love.graphics.getWidth() / box.width,
            height = self.dim.height * love.graphics.getHeight() / box.height
        }

        return {
            x = (pos.x - box.x + box.width / 2) / box.width * love.graphics.getWidth() - spriteDim.width / 2,
            y = (pos.y - box.y + box.height / 2) / box.height * love.graphics.getHeight() - spriteDim.height,
            width = spriteDim.width,
            height = spriteDim.height
        }
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
            y = (pos.y - box.y + box.height / 2) / box.height * love.graphics.getHeight() - region.height * scale.y
        }

        love.graphics.draw(
            animation.spritesheet,
            animation.quads[self.frameIndex],
            drawPos.x + inversionOffset.x,
            drawPos.y + inversionOffset.y,
            region.rotation or 0,
            scale.x * (region.invertX and -1 or 1),
            scale.y * (region.invertY and -1 or 1)
        )
    end

    return sprite
end
