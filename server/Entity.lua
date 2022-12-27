local interpolate = require 'common.utils.interpolate'
local SynchronisedTable = require 'common.communication.SynchronisedTable'
local LayeredSprite = require 'client.LayeredSprite'
local Sprite = require 'client.Sprite'
local Hitbox = require 'common.types.Hitbox'

return function(args, age)
    local entity = {}

    entity.maxHealth = args.maxHealth
    entity.health = args.maxHealth
    entity.alive = true

    entity.speed = args.speed
    entity.label = args.label

    entity.data =
        SynchronisedTable(
        {
            id = args.id,
            radius = args.width * 0.4,
            pos = {x = args.x, y = args.y}
        },
        age
    )

    function entity:setDest(x, y)
        self.data.dest = {x = x, y = y}
    end

    function entity:update(age)
        self.data:setAge(age)
        if self.data.dest == nil or self.data.dest.x == self.data.pos.x and self.data.dest.y == self.data.pos.y then
            self.data.dest = nil
            return
        end

        local posDiff = {
            x = self.data.dest.x - self.data.pos.x,
            y = self.data.dest.y - self.data.pos.y
        }
        local sqrMagnitude = posDiff.x ^ 2 + posDiff.y ^ 2

        local nextPos
        if sqrMagnitude <= self.speed ^ 2 then
            nextPos = self.data.dest
        else
            local magnitude = math.sqrt(sqrMagnitude)
            local normalised = {
                x = posDiff.x / magnitude,
                y = posDiff.y / magnitude
            }
            nextPos = {
                x = self.data.pos.x + normalised.x * self.speed,
                y = self.data.pos.y + normalised.y * self.speed
            }
        end

        self.data.pos.x = nextPos.x
        self.data.pos.y = nextPos.y
    end

    function entity:damage(amount)
        self.health = math.max(self.health - amount, 0)
        if self.health == 0 then
            self.alive = false
        end
    end

    return entity
end
