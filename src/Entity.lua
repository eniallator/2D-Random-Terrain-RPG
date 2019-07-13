local Sprite = require 'src.Sprite'

return function(speed, width, height, nextFrameDistance)
    local entity = {}

    entity.sprite = Sprite(width, height)
    entity.pos = {x = 0, y = 0}
    entity.drawPos = {x = entity.pos.x, y = entity.pos.y}
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
            local diff = {x = self.pos.x - self.dest.x, y = self.pos.y - self.dest.y}
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
            x = self.dest.x - self.pos.x,
            y = self.dest.y - self.pos.y
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
                x = self.pos.x + normalised.x * self.speed,
                y = self.pos.y + normalised.y * self.speed
            }
        end

        self.oldPos = {
            x = self.pos.x,
            y = self.pos.y
        }
        self.pos.x = nextPos.x
        self.pos.y = nextPos.y
    end

    function entity:update()
        if self.autoAnimation then
            updateSprite(self)
        end
        updatePos(self)
    end

    function entity:calcDraw(dt, scale)
        self.drawPos.x = self.pos.x
        self.drawPos.y = self.pos.y

        if self.oldPos ~= nil then
            local posDiff = {
                x = self.pos.x - self.oldPos.x,
                y = self.pos.y - self.oldPos.y
            }
            self.drawPos.x = self.oldPos.x + posDiff.x * dt
            self.drawPos.y = self.oldPos.y + posDiff.y * dt
        end
    end

    function entity:draw(box)
        -- interpolate from oldPos to pos with sprite:draw
        self.sprite:draw(self.drawPos, box)
    end

    return entity
end
