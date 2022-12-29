local config = require 'conf'
local Entity = require 'server.Entity'
local ClassLookup = require 'server.class.ClassLookup'

return function(initialData)
    local playerArgs = {
        x = x,
        y = y,
        speed = 8 / config.tps,
        width = config.entity.player.width,
        height = config.entity.player.height,
        maxHealth = config.entity.player.health,
        initialData = initialData
    }
    local player = Entity(playerArgs)

    player.class = ClassLookup[initialData.class]()

    local oldUpdate = player.update
    local abilityLastUsed = nil
    function player:update(age, map, shouldSimulate)
        if
            self.data.lastAbility.id ~= nil and
                (abilityLastUsed == nil or self.data.lastAbility:getLastAge() > abilityLastUsed)
         then
            abilityLastUsed = self.data.lastAbility:getLastAge()
            self.class:useAbility(
                self.data.lastAbility.id,
                {map = map, castedBy = self, toPos = self.data.lastAbility.toPos, age = age}
            )
        end

        oldUpdate(self, age, shouldSimulate)
    end

    return player
end
