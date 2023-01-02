local config = require 'conf'
local NetworkApi = require 'server.communication.NetworkApi'
local GameLoopController = require 'common.GameLoopController'
local Map = require 'server.environment.Map'

return function()
    local main =
        GameLoopController(
        NetworkApi(
            {
                environment = {
                    playerChunkRadius = config.playerChunkRadius,
                    chunks = {}
                },
                players = {},
                mobs = {},
                projectiles = {},
                player = {}
            }
        ),
        config.tps
    )
    main.channel = love.thread.getChannel('SERVER')
    main.running = true
    main.map = Map(config.mapSeed)

    if timeAnalysis then
        timeAnalysis.registerMethods(main.map, 'Map', true)
        timeAnalysis.registerMethods(main.networkApi, 'NetworkApi', true)
        timeAnalysis.registerMethods(main, 'Main')
    end

    function main:updateTick(connectionsLocalState, connectionsReceivedState)
        local message = self.channel:pop()
        while message do
            if message == 'kill' then
                self.running = false
                return
            end
            message = self.channel:pop()
        end

        self.map:update(connectionsLocalState, connectionsReceivedState, self.age)
    end

    return main
end
