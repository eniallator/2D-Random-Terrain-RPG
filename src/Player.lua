local config = require 'conf'
local Entity = require 'src.Entity'

return function(spriteType)
    local player = Entity(8 / config.tps, 3, 4)
    local super = Entity()

    player.spriteType = spriteType

    player.deltaMoved = 0
    player.nextFrameDistance = 1.5

    player.frameWidth = 16
    player.frameHeight = 24
    player.sprite:setDefaultAnimation('idle')
    player.sprite:addAnimation(
        'idle',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 0,
                width = player.frameWidth,
                height = player.frameHeight
            }
        }
    )
    player.sprite:addAnimation(
        'down',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 0,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight,
                invertX = true
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 0,
                width = player.frameWidth,
                height = player.frameHeight
            }
        }
    )
    player.sprite:addAnimation(
        'right',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 3 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 2 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            }
        }
    )
    player.sprite:addAnimation(
        'left',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 3 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight,
                invertX = true
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 2 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight,
                invertX = true
            }
        }
    )
    player.sprite:addAnimation(
        'up',
        ASSETS.textures.player.spritesheet,
        {
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 5 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 4 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 5 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight,
                invertX = true
            },
            {
                x = (player.spriteType - 1) * player.frameWidth,
                y = 4 * player.frameHeight,
                width = player.frameWidth,
                height = player.frameHeight
            }
        }
    )

    function player:update()
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
        super.update(self)
    end

    return player
end
