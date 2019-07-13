local config = require 'conf'
local Entity = require 'src.Entity'

local types = {
    {path = ASSETS.textures.entity.zombie.knight, col = 1},
    {path = ASSETS.textures.entity.zombie.knight, col = 2},
    {path = ASSETS.textures.entity.zombie.bald, col = 1},
    {path = ASSETS.textures.entity.zombie.bald, col = 2},
    {path = ASSETS.textures.entity.zombie.bald, col = 3}
}

return function(type)
    local zombie = Entity(8 / config.tps, 3, 4, 1.5)
    local super = Entity()

    local spritesheet = types[type].path
    local colOffset = (types[type].col - 1) * 3 * spritesheet.width

    zombie.sprite:setDefaultAnimation('idle')
    zombie.sprite:addAnimation(
        'idle',
        spritesheet.img,
        {
            {
                x = 1 * spritesheet.width + colOffset,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    zombie.sprite:addAnimation(
        'down',
        spritesheet.img,
        {
            {
                x = 2 * spritesheet.width + colOffset,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 0,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 2 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    zombie.sprite:addAnimation(
        'right',
        spritesheet.img,
        {
            {
                x = 2 * spritesheet.width + colOffset,
                y = 1 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 1 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 0,
                y = 1 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 1 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    zombie.sprite:addAnimation(
        'left',
        spritesheet.img,
        {
            {
                x = 2 * spritesheet.width + colOffset,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 0,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 3 * spritesheet.height,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    zombie.sprite:addAnimation(
        'up',
        spritesheet.img,
        {
            {
                x = 2 * spritesheet.width + colOffset,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 0,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            },
            {
                x = 1 * spritesheet.width + colOffset,
                y = 0,
                width = spritesheet.width,
                height = spritesheet.height
            }
        }
    )
    zombie.moveTime = nil

    function zombie:update()
        local cfg = config.entity.zombie
        if self.dest == nil then
            if self.moveTime == nil then
                self.moveTime = love.timer.getTime() + cfg.idleTime.min + love.math.random() * (cfg.idleTime.max - cfg.idleTime.min)
            elseif love.timer.getTime() > self.moveTime then
                self.moveTime = nil
                local ranOutput = {
                    x = love.math.random() * (cfg.walkRange.max - cfg.walkRange.min) - (cfg.walkRange.max - cfg.walkRange.min) / 2,
                    y = love.math.random() * (cfg.walkRange.max - cfg.walkRange.min) - (cfg.walkRange.max - cfg.walkRange.min) / 2
                }
                local dest = {
                    x = self.pos.x + ranOutput.x + (ranOutput.x >= 0 and cfg.walkRange.min or -cfg.walkRange.min),
                    y = self.pos.y + ranOutput.y + (ranOutput.y >= 0 and cfg.walkRange.min or -cfg.walkRange.min)
                }
                self:setDest(dest.x, dest.y)
            end
        end
        super.update(self)
    end

    return zombie
end