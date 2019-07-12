return function(sprite, speed, x, y)
    local entity = {}

    entity.sprite = sprite
    entity.pos = {x = x or 0, y = y or 0}
    entity.drawPos = {x = entity.pos.x, y = entity.pos.y}
    entity.speed = speed

    function entity:setDest(x, y)
        self.dest = {x = x, y = y}
    end

    function entity:update()
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

    function entity:draw(dt)
        -- interpolate from oldPos to pos with sprite:draw
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
        self.sprite:draw(self.drawPos)
    end

    return entity
end
