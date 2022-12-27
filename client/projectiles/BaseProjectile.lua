local Sprite = require 'client.Sprite'
local hitbox = require 'common.types.Hitbox'

return function(args)
    local baseProjectile = {}

    baseProjectile.sprite = Sprite(args.width, args.height)
    baseProjectile.speed = args.speed
    baseProjectile.range = args.range
    baseProjectile.damage = args.damage
    baseProjectile.nextFrameDist = args.nextFrameDist
    baseProjectile.directionNorm = args.directionNorm
    baseProjectile.hitbox = hitbox(args.pos.x, args.pos.y, args.width * 0.8)

    baseProjectile.oldPos = {x = baseProjectile.hitbox.x, y = baseProjectile.hitbox.y}
    baseProjectile.drawPos = {x = baseProjectile.hitbox.x, y = baseProjectile.hitbox.y}

    baseProjectile.deltaMoved = 0
    baseProjectile.distTravelled = 0
    baseProjectile.alive = true
    baseProjectile.autoAnimation = true

    local function updateSprite(self)
        if self.deltaMoved > self.nextFrameDist then
            self.sprite:advanceAnimation(math.floor(self.deltaMoved / self.nextFrameDist))
            self.deltaMoved = self.deltaMoved % self.nextFrameDist
        end

        self.deltaMoved = self.deltaMoved + self.speed
    end

    function baseProjectile:update(mobs)
        if self.autoAnimation then
            updateSprite(self)
        end

        if self.distTravelled > self.range then
            self.alive = false
        end

        for _, mob in ipairs(mobs) do
            if self.hitbox:collide(mob.hitbox) then
                mob:damage(self.damage)
                self.alive = false
                break
            end
        end

        self.distTravelled = self.distTravelled + self.speed
        self.oldPos.x = self.hitbox.x
        self.oldPos.y = self.hitbox.y
        self.hitbox.x = self.hitbox.x + self.directionNorm.x * self.speed
        self.hitbox.y = self.hitbox.y + self.directionNorm.y * self.speed
    end

    function baseProjectile:calcDraw(dt)
        self.drawPos.x = self.oldPos.x + (self.hitbox.x - self.oldPos.x) * dt
        self.drawPos.y = self.oldPos.y + (self.hitbox.y - self.oldPos.y) * dt
    end

    function baseProjectile:draw(box)
        self.sprite:draw(self.drawPos, box)
    end

    return baseProjectile
end
