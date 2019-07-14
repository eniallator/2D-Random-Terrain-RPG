local Sprite = require 'src.Sprite'
local Hitbox = require 'src.Hitbox'

return function(speed, width, height, nextFrameDistance, maxHealth)
    local entity = {}

    entity.maxHealth = maxHealth
    entity.health = entity.maxHealth

    entity.spriteDim = {width = width, height = height}
    entity.sprite = Sprite(width, height)
    entity.hitbox = Hitbox(0, 0, width * 0.8)
    entity.drawPos = {x = entity.hitbox.x, y = entity.hitbox.y}
    entity.speed = speed
    entity.autoAnimation = true

    entity.deltaMoved = 0
    entity.nextFrameDistance = nextFrameDistance

    function entity:setDest(x, y)
        self.dest = {x = x, y = y}
    end

    local function updateSprite(self)
        if not self.dest then
            if self.sprite.playingAnimation ~= 'idle' then
                self.sprite:playAnimation('idle')
            end
        else
            local diff = {x = self.hitbox.x - self.dest.x, y = self.hitbox.y - self.dest.y}
            local direction

            if math.abs(diff.x) > math.abs(diff.y) then
                direction = diff.x < 0 and 'right' or 'left'
            else
                direction = diff.y < 0 and 'down' or 'up'
            end

            if self.sprite.playingAnimation ~= direction then
                self.sprite:playAnimation(direction)
            end

            local dist = math.min(self.speed, math.sqrt(diff.x ^ 2 + diff.y ^ 2))
            self.deltaMoved = self.deltaMoved + dist
            if self.deltaMoved > self.nextFrameDistance then
                self.sprite:advanceAnimation(math.floor(self.deltaMoved / self.nextFrameDistance))
                self.deltaMoved = self.deltaMoved % self.nextFrameDistance
            end
        end
    end

    local function updatePos(self)
        if self.dest == nil then
            self.oldPos = nil
            return
        end

        local posDiff, nextPos = {
            x = self.dest.x - self.hitbox.x,
            y = self.dest.y - self.hitbox.y
        }
        local magnitude = math.sqrt(posDiff.x ^ 2 + posDiff.y ^ 2)

        if magnitude <= self.speed then
            nextPos = self.dest
            self.dest = nil
        else
            local normalised = {
                x = posDiff.x / magnitude,
                y = posDiff.y / magnitude
            }
            nextPos = {
                x = self.hitbox.x + normalised.x * self.speed,
                y = self.hitbox.y + normalised.y * self.speed
            }
        end

        self.oldPos = {
            x = self.hitbox.x,
            y = self.hitbox.y
        }
        self.hitbox.x = nextPos.x
        self.hitbox.y = nextPos.y
    end

    function entity:update()
        if self.autoAnimation then
            updateSprite(self)
        end
        updatePos(self)
    end

    function entity:calcDraw(dt, scale)
        self.drawPos.x = self.hitbox.x
        self.drawPos.y = self.hitbox.y

        if self.oldPos ~= nil then
            local posDiff = {
                x = self.hitbox.x - self.oldPos.x,
                y = self.hitbox.y - self.oldPos.y
            }
            self.drawPos.x = self.oldPos.x + posDiff.x * dt
            self.drawPos.y = self.oldPos.y + posDiff.y * dt
        end
    end

    function entity:drawShadow(box)
        local scale = {
            x = love.graphics.getWidth() / box.width,
            y = love.graphics.getHeight() / box.height
        }

        local frameBox = self.sprite:getFrameBox(self.drawPos, box)
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.ellipse(
            'fill',
            frameBox.x + self.spriteDim.width / 2 * scale.x,
            frameBox.y + self.spriteDim.height * scale.y,
            self.hitbox.diameter / 2 * scale.x,
            self.hitbox.diameter / 2 * scale.y / 1.5
        )
        love.graphics.setColor(1, 1, 1, 1)
    end

    local function drawHealth(self, box)
        local frameBox = self.sprite:getFrameBox(self.drawPos, box)
        local healthBox = {
            x = frameBox.x,
            y = frameBox.y - frameBox.height / 4,
            width = frameBox.width,
            height = frameBox.height / 10
        }

        -- love.graphics.setColor(0, 0, 1)
        -- love.graphics.rectangle('line', frameBox.x, frameBox.y, frameBox.width, frameBox.height)

        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('fill', healthBox.x, healthBox.y, healthBox.width, healthBox.height)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle('fill', healthBox.x, healthBox.y, healthBox.width * self.health / self.maxHealth, healthBox.height)
        love.graphics.setColor(1, 1, 1)
    end

    function entity:draw(box)
        self.sprite:draw(self.drawPos, box)
        if self.health < self.maxHealth then
            drawHealth(self, box)
        end
    end

    return entity
end
