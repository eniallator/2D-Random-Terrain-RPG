local config = require 'conf'
local NetworkApi = require 'client.communication.NetworkApi'
local GameLoop = require 'client.GameLoop'
local BaseGui = require 'client.gui.BaseGui'

-- Handles the game loop cycle as well as network messages
return function(menuState)
    local game = BaseGui()

    game.networkApi =
        NetworkApi(
        {
            player = {
                nickname = menuState.nickname,
                spriteData = menuState.spriteData,
                pos = {
                    current = {
                        x = 0,
                        y = 0
                    },
                    dest = {
                        x = 0,
                        y = 0
                    }
                }
            },
            environment = {chunksReceived = nil}
        }
    )

    if menuState.multiplayer ~= nil then
        game.networkApi:connect(menuState.multiplayer.address, menuState.multiplayer.port)
    else
        game.serverThread = love.thread.newThread('server/Engine.lua')
        game.serverThread:start()
        game.serverChannel = love.thread.getChannel('SERVER')

        game.networkApi:connect(config.communication.address, config.communication.port)
    end

    game.gameLoop = GameLoop(menuState)
    game.tickLength = 1 / config.tps
    game.lastClockTime = os.clock()
    game.dtAccumulated = 0
    game.age = 0

    function game:updateInputs()
        -- no op since they need to be updated after the update tick
    end

    function game:resize(width, height)
        self.gameLoop:resize(width, height)
    end

    function game:update(menuState)
        self.networkApi:checkForUpdates(self.age)

        local now = os.clock()
        self.dtAccumulated = self.dtAccumulated + now - self.lastClockTime
        self.lastClockTime = now

        local ticked = false
        while self.dtAccumulated > self.tickLength do
            self.age = self.age + 1
            self.networkApi:setAge(self.age)
            self.dtAccumulated = self.dtAccumulated - self.tickLength
            ticked = true
            self.gameLoop:update(self.networkApi:getLocalState(), self.networkApi:getReceivedState(), menuState)
            if
                self.networkApi.lastReceived ~= nil and self.serverThread == nil and
                    self.age > self.networkApi.lastReceived + config.communication.timeoutTicks
             then
                menuState.scene = 'mainMenu'
            end

            if self.serverThread ~= nil then
                local serverError = self.serverThread:getError()
                if serverError then
                    error(serverError)
                end
            end
            if menuState.scene ~= 'game' then
                self.networkApi:disconnect()
                if self.serverThread ~= nil then
                    self.serverChannel:push('kill')
                    self.serverThread:wait()
                end
            end
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
