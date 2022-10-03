local config = require 'conf'
local NetworkApi = require 'server.communication.NetworkApi'
local GameLoopController = require 'common.GameLoopController'
local Map = require 'server.environment.Map'

return function()
    local main = GameLoopController(NetworkApi({environment = {}}), config.tps)
    main.map = Map(config.mapSeed)

    function main:updateTick(connectionsLocalState, connectionsReceivedState)
        -- All server-side game logic happening here
        self.map:update(connectionsLocalState, connectionsReceivedState)
    end

    return main
end
