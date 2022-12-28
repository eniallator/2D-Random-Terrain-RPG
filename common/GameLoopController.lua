-- Base class which is inherited from for the update tick method
return function(networkApi, tps)
    local gameLoopController = {}

    gameLoopController.networkApi = networkApi
    gameLoopController.tickLength = 1 / tps
    gameLoopController.networkTickLength = gameLoopController.tickLength / tps

    gameLoopController.dtAccumulated = 0
    gameLoopController.networkDtAccumulated = 0
    gameLoopController.age = 0

    function gameLoopController:update(dt)
        self.networkDtAccumulated = self.networkDtAccumulated + dt

        while self.networkDtAccumulated > self.networkTickLength do
            self.networkApi:checkForUpdates(self.age - 1)
            self.networkDtAccumulated = self.networkDtAccumulated - self.networkTickLength
        end

        self.dtAccumulated = self.dtAccumulated + dt
        local ticked = false
        while self.dtAccumulated > self.tickLength do
            self.age = self.age + 1
            self.networkApi:setAge(self.age)
            self.dtAccumulated = self.dtAccumulated - self.tickLength
            ticked = true
            self:updateTick(self.networkApi:getLocalState(), self.networkApi:getReceivedState())
        end

        if ticked then
            self.networkApi:flushUpdates(self.age)
        end
    end

    function gameLoopController:updateTick(localState, receivedState)
        error('Must define an updateTick method on the game loop sub class')
    end

    function gameLoopController:draw()
        self:drawWithDt(
            self.networkApi:getLocalState(),
            self.networkApi:getReceivedState(),
            self.dtAccumulated / self.tickLength
        )
    end

    function gameLoopController:drawWithDt(localState, receivedState, dt)
        error('Must define a draw method on the game loop sub class')
    end

    return gameLoopController
end
