local function sprite(imgPath, frameWidth, frameHeight)
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

    return sprite
end

return sprite
