local config = require 'conf'
local Entity = require 'server.Entity'
local EnemyBehaviour = require 'server.EnemyBehaviour'

return function(variant, x, y, id, age)
    local zombieArgs = {
        id = id .. '.zombie.' .. variant,
        speed = 5 / config.tps,
        x = x,
        y = y,
        width = 3,
        height = 4,
        maxHealth = config.entity.player.health
    }
    local zombie = Entity(zombieArgs, age)
    local super = Entity(zombieArgs)

    zombie.nearbyPlayers = {}
    zombie.behaviour = EnemyBehaviour(config.entity.zombie)

    function zombie:update(age)
        self.behaviour:autoUpdate(self, self.nearbyPlayers)
        super.update(self, age)
    end

    return zombie
end
