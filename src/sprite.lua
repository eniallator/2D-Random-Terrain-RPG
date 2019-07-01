local function sprite(imgPath, frameWidth, frameHeight)
    local sprite = {}
    sprite.spriteSheet = love.graphics.newImage(imgPath)
    sprite.frameDim = {width = frameWidth, height = frameHeight}
    sprite.frames = {
        x = math.floor(sprite.spriteSheet:getWidth() / sprite.frameDim.width),
        y = math.floor(sprite.spriteSheet:getHeight() / sprite.frameDim.height)
    }
    sprite.currFrame = 0

    function sprite:nextframe()
        self.currFrame = (self.currFrame + 1) % self.totalFrames
    end

    function sprite:getFrameQuad()
        local pos = {x = self.currFrame % self.frames.x, y = math.floor(self.currFrame / self.frames.y)}
        return sprite.spriteSheet, love.graphics.newQuad(
            pos.x,
            pos.y,
            sprite.frameDim.width,
            sprite.frameDim.height,
            self.spriteSheet:getDimensions()
        )
    end

    return sprite
end

return sprite
