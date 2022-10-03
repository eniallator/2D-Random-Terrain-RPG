local config = require 'conf'
local NetworkApi = require 'server.communication.NetworkApi'
local GameLoopController = require 'common.GameLoopController'
local Map = require 'server.environment.Map'

return function()
    local main = GameLoopController(NetworkApi({environment = {}, players = {}}), config.tps)
    main.map = Map(config.mapSeed)

    function main:updateTick(connectionsLocalState, connectionsReceivedState)
        -- All server-side game logic happening here
        self.map:update(connectionsLocalState, connectionsReceivedState)
        for id, state in connectionsLocalState.subTablePairs() do
            for otherId, connection in connectionsReceivedState.subTablePairs() do
                if id ~= otherId then
                    state.players[otherId] = connection.state.player
                end
            end
        end
    end

    return main
end
