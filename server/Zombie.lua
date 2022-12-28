local config = require 'conf'
local Entity = require 'server.Entity'
local EnemyBehaviour = require 'server.EnemyBehaviour'

return function(variant, x, y, age)
    local zombieArgs = {
        id = 'zombie.' .. variant,
        speed = 5 / config.tps,
        x = x,
        y = y,
        width = 3,
        height = 4,
        maxHealth = config.entity.player.health
    }
    local zombie = Entity(zombieArgs, age)

    zombie.nearbyPlayers = {}
    zombie.behaviour = EnemyBehaviour(config.entity.zombie)

    local oldUpdate = zombie.update

    function zombie:update(age)
        self.behaviour:autoUpdate(self, self.nearbyPlayers)
        oldUpdate(self, age)
    end

    return zombie
end
