local config = require 'conf'
local collide = require 'common.utils.collide'
local Projectile = require 'server.Projectile'

return function(id, age, args)
    local targetter = Projectile(id, age, args)

    targetter.target = args.target

    function targetter:update(mobs)
        if self.autoAnimation then
            updateSprite(self)
        end

        if self.range and self.distTravelled > self.range then
            self.alive = false
        end

        local targetData = self.target:getData()
        if
            collide.circles(
                self.data.pos.current.x,
                self.data.pos.current.y,
                self.radius,
                targetData.pos.current.x,
                targetData.pos.current.y,
                self.target.radius
            )
         then
            self.target:damage(self.damage)
            self.alive = false
        end

        local diff = {
            x = targetData.pos.current.x - self.data.pos.current.x,
            y = targetData.pos.current.y - self.data.pos.current.y
        }
        local directionNorm = {
            x = diff.x / (math.abs(diff.x) + math.abs(diff.y)),
            y = diff.y / (math.abs(diff.x) + math.abs(diff.y))
        }

        self.distTravelled = self.distTravelled + self.speed
        self.data.pos.current.x = self.data.pos.current.x + directionNorm.x * self.speed
        self.data.pos.current.y = self.data.pos.current.y + directionNorm.y * self.speed
    end

    return targetter
end
