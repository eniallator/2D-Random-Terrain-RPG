return function(imgPath, frameWidth, frameHeight)
    local sprite = {}
    sprite.spriteSheet = love.graphics.newImage(imgPath)
    sprite.frameDim = {
        width = frameWidth or sprite.spriteSheet:getWidth(),
        height = frameHeight or frameWidth or sprite.spriteSheet:getHeight()
    }
    sprite.frames = {
        x = math.floor(sprite.spriteSheet:getWidth() / sprite.frameDim.width),
        y = math.floor(sprite.spriteSheet:getHeight() / sprite.frameDim.height)
    }
    sprite.currFrame = 0

    function sprite:nextFrame()
        self.currFrame = (self.currFrame + 1) % (self.frames.x * self.frames.y)
    end

    function sprite:getFrameQuad()
        local pos = {x = self.currFrame % self.frames.x, y = math.floor(self.currFrame / self.frames.y)}

        return love.graphics.newQuad(
            pos.x * sprite.frameDim.width,
            pos.y * sprite.frameDim.height,
            sprite.frameDim.width,
            sprite.frameDim.height,
            self.spriteSheet:getDimensions()
        )
    end

    function sprite:draw(pos, box)
        -- love.graphics.draw(self.spriteSheet, self:getFrameQuad(), pos.x - self.frameDim.width / 2, pos.y - self.frameDim.height / 2)
        love.graphics.draw(
            self.spriteSheet,
            self:getFrameQuad(),
            (pos.x - box.x + box.width / 2) / box.width * love.graphics.getWidth() - self.frameDim.width / 2,
            (pos.y - box.y + box.height / 2) / box.height * love.graphics.getHeight() - self.frameDim.height / 2
        )
    end

    return sprite
end
