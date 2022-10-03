local config = require 'conf'
local NetworkApi = require 'client.communication.NetworkApi'
local GameLoop = require 'client.GameLoop'
local BaseGui = require 'client.gui.BaseGui'

-- Handles the game loop cycle as well as network messages
return function(menuState)
    local game = BaseGui()

    if menuState.multiplayer == nil then
        -- Want to save data before killing thread, so will wait until it's done
        local serverThread = love.thread.newThread('server/Engine.lua')
        serverThread:start()
    end

    game.gameLoop = GameLoop(menuState)
    game.networkApi =
        NetworkApi(
        {
            player = {
                pos = {
                    x = 0,
                    y = 0
                }
            },
            environment = {
                chunkIds = {}
            }
        }
    )
    game.tickLength = 1 / config.tps
    game.lastClockTime = os.clock()
    game.dtAccumulated = 0
    game.age = 0

    game.networkApi:connect(config.communication.address, config.communication.port)

    function game:updateInputs()
        -- no op since they need to be updated after the update tick
    end

    function game:resize(width, height)
        self.gameLoop:resize(width, height)
    end

    function game:update(menuState)
        self.networkApi:checkForUpdates(self.age - 1)

        local now = os.clock()
        self.dtAccumulated = self.dtAccumulated + now - self.lastClockTime
        self.lastClockTime = now

        local ticked = false
        while self.dtAccumulated > self.tickLength do
            self.age = self.age + 1
            self.networkApi:setAge(self.age)
            self.dtAccumulated = self.dtAccumulated - self.tickLength
            ticked = true
            self.gameLoop:update(self.networkApi:getLocalState(), self.networkApi:getReceivedState())
            MOUSE.updateValues()
            KEYS.updateRecentPressed()
        end

        if ticked then
            self.networkApi:flushUpdates(self.age)
        end
    end

    function game:draw(dt)
        self.gameLoop:draw(
            self.networkApi:getLocalState(),
            self.networkApi:getReceivedState(),
            self.dtAccumulated / self.tickLength
        )
    end

    return game
end
