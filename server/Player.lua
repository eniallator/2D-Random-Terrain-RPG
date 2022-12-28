local config = require 'conf'
local Entity = require 'server.Entity'

return function()
    local playerArgs = {
        x = x,
        y = y,
        speed = 8 / config.tps,
        width = config.entity.player.width,
        height = config.entity.player.height,
        maxHealth = config.entity.player.health
    }
    local player = Entity(playerArgs)

    return player
end
