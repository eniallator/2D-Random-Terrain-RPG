return function(sprite, speed, x, y)
    local entity = {}

    entity.oldPos = {x = x or 0, y = y or 0}
    entity.pos = {x = x or 0, y = y or 0}
    entity.sprite = sprite
    entity.speed = speed

    function entity:setDest(x, y)
        self.dest = {x = x, y = y}
    end

    function entity:update()
        if self.dest == nil then
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
                x = normalised.x * self.speed,
                y = normalised.y * self.speed
            }
        end

        self.oldPos = self.pos
        self.pos = nextPos
    end

    function entity:draw(dt)
        -- interpolate from oldPos to pos with sprite:draw
    end
end
