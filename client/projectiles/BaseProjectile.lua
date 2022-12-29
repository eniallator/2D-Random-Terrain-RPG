local Sprite = require 'client.Sprite'
local collide = require 'common.utils.collide'
local interpolate = require 'common.utils.interpolate'

return function(args)
    local baseProjectile = {}

    baseProjectile.sprite = Sprite(args.width, args.height)
    baseProjectile.nextFrameDist = args.nextFrameDist
    baseProjectile.radius = args.width * 0.4
    baseProjectile.data = args.data

    baseProjectile.oldPos = {x = args.data.pos.current.x, y = args.data.pos.current.y}
    baseProjectile.drawPos = {x = args.data.pos.current.x, y = args.data.pos.current.y}

    baseProjectile.deltaMoved = 0

    local function updateSprite(self, diff)
        if self.deltaMoved > self.nextFrameDist then
            self.sprite:advanceAnimation(math.floor(self.deltaMoved / self.nextFrameDist))
            self.deltaMoved = self.deltaMoved % self.nextFrameDist
        end

        self.deltaMoved = self.deltaMoved + diff
    end

    function baseProjectile:update()
        updateSprite(
            self,
            collide.getDist(self.oldPos.x, self.oldPos.y, self.data.pos.current.x, self.data.pos.current.y)
        )
        self.oldPos.x = self.data.pos.current.x
        self.oldPos.y = self.data.pos.current.y
    end

    function baseProjectile:calcDraw(dt)
        self.drawPos.x = interpolate.linear(dt, self.oldPos.x, self.data.pos.current.x)
        self.drawPos.y = interpolate.linear(dt, self.oldPos.y, self.data.pos.current.y)
    end

    function baseProjectile:draw(box)
        self.sprite:draw(self.drawPos, box)
    end

    return baseProjectile
end
