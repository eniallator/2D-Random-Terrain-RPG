local collide = require 'common.utils.collide'
local SynchronisedTable = require 'common.communication.SynchronisedTable'

return function(id, age, args)
    local projectile = {}

    projectile.speed = args.speed
    projectile.range = args.range
    projectile.damage = args.damage
    projectile.directionNorm = args.directionNorm
    projectile.radius = args.width * 0.4

    projectile.data =
        SynchronisedTable(
        {
            id = id,
            pos = {current = {x = args.pos.x, y = args.pos.y}}
        },
        age
    )

    projectile.distTravelled = 0
    projectile.alive = true

    function projectile:getData()
        return self.data
    end

    function projectile:update(mobs)
        if self.distTravelled > self.range then
            self.alive = false
            return
        end

        local _, mob
        for _, mob in pairs(mobs) do
            local mobData = mob:getData()
            if
                collide.circles(
                    self.data.pos.current.x,
                    self.data.pos.current.y,
                    self.radius,
                    mobData.pos.current.x,
                    mobData.pos.current.y,
                    mob.radius
                )
             then
                mob:damage(self.damage)
                self.alive = false
                return
            end
        end

        self.distTravelled = self.distTravelled + self.speed
        self.data.pos.current.x = self.data.pos.current.x + self.directionNorm.x * self.speed
        self.data.pos.current.y = self.data.pos.current.y + self.directionNorm.y * self.speed
    end

    return projectile
end
