local config = require 'conf'
local Hitbox = require 'client.Hitbox'
local BaseProjectile = require 'client.projectiles.BaseProjectile'

return function(fromPos, target, cfg)
    local targetter =
        BaseProjectile(
        {
            width = 1,
            height = 1,
            speed = config.tps / 8,
            range = cfg.range,
            damage = cfg.damage,
            pos = fromPos,
            directionNorm = directionNorm,
            nextFrameDist = 3.5
        }
    )

    targetter.target = target

    local spritesheet = ASSETS.textures.projectile.whirlwind
    targetter.sprite:setDefaultAnimation('moving')
    targetter.sprite:addAnimation(
        'moving',
        spritesheet.img,
        {
            {
                x = 0,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 2 * spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 2 * spritesheet.width,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )

    local function updateSprite(self)
        if self.deltaMoved > self.nextFrameDist then
            self.sprite:advanceAnimation(math.floor(self.deltaMoved / self.nextFrameDist))
            self.deltaMoved = self.deltaMoved % self.nextFrameDist
        end

        self.deltaMoved = self.deltaMoved + self.speed
    end

    function targetter:update(mobs)
        if self.autoAnimation then
            updateSprite(self)
        end

        if self.range and self.distTravelled > self.range then
            self.alive = false
        end

        if self.hitbox:collide(self.target.hitbox) then
            self.target:damage(self.damage)
            self.alive = false
        end

        local diff = {
            x = self.target.hitbox.x - self.hitbox.x,
            y = self.target.hitbox.y - self.hitbox.y
        }
        local directionNorm = {
            x = diff.x / (math.abs(diff.x) + math.abs(diff.y)),
            y = diff.y / (math.abs(diff.x) + math.abs(diff.y))
        }

        self.distTravelled = self.distTravelled + self.speed
        self.oldPos.x = self.hitbox.x
        self.oldPos.y = self.hitbox.y
        self.hitbox.x = self.hitbox.x + directionNorm.x * self.speed
        self.hitbox.y = self.hitbox.y + directionNorm.y * self.speed
    end

    return targetter
end
