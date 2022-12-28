local interpolate = require 'common.utils.interpolate'
local SynchronisedTable = require 'common.communication.SynchronisedTable'
local LayeredSprite = require 'client.LayeredSprite'
local Sprite = require 'client.Sprite'
local Hitbox = require 'common.types.Hitbox'

return function(args, age)
    local entity = {}

    entity.radius = args.width * 0.4
    entity.speed = args.speed

    entity.data =
        SynchronisedTable(
        {
            id = args.id,
            pos = {
                current = {x = args.x, y = args.y},
                dest = nil
            },
            alive = true,
            maxHealth = args.maxHealth,
            health = args.maxHealth
        },
        age
    )
    if args.initialData then
        for key, val in args.initialData:dataPairs() do
            entity.data[key] = val
        end
        for key, val in args.initialData:subTablePairs() do
            entity.data[key] = val
        end
    end

    function entity:getData(keys)
        if keys then
            local newData = SynchronisedTable(nil, self.data:getLastAge())
            for _, key in ipairs(keys) do
                newData[key] = self.data[key]
            end
            return newData
        else
            return self.data
        end
    end

    function entity:setDest(x, y)
        self.data.pos.dest = {x = x, y = y}
        self.data:forceUpdate(true)
    end

    function entity:clearDest()
        self.data.pos.dest = nil
        self.data:forceUpdate(true)
    end

    function entity:setPosData(pos)
        entity.data.pos = pos
    end

    function entity:update(age)
        self.data:setAge(age)
        if
            self.data.pos.dest == nil or
                self.data.pos.dest.x == self.data.pos.current.x and self.data.pos.dest.y == self.data.pos.current.y
         then
            self:clearDest()
            return
        end

        local posDiff = {
            x = self.data.pos.dest.x - self.data.pos.current.x,
            y = self.data.pos.dest.y - self.data.pos.current.y
        }
        local sqrMagnitude = posDiff.x ^ 2 + posDiff.y ^ 2

        local nextPos
        if sqrMagnitude <= self.speed ^ 2 then
            nextPos = self.data.pos.dest
        else
            local magnitude = math.sqrt(sqrMagnitude)
            local normalised = {
                x = posDiff.x / magnitude,
                y = posDiff.y / magnitude
            }
            nextPos = {
                x = self.data.pos.current.x + normalised.x * self.speed,
                y = self.data.pos.current.y + normalised.y * self.speed
            }
        end

        self.data:forceUpdate(true)
        self.data.pos.current.x = nextPos.x
        self.data.pos.current.y = nextPos.y
    end

    function entity:damage(amount)
        if self.data.alive then
            self.data.health = math.max(self.data.health - amount, 0)
            self.data.alive = self.data.health > 0
        end
    end

    return entity
end
