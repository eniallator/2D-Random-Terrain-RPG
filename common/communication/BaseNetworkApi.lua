local SynchronisedTable = require 'common.communication.SynchronisedTable'

return function(initialLocalState)
    local baseNetworkApi = {}

    baseNetworkApi.__localState = SynchronisedTable(initialLocalState)
    baseNetworkApi.__lastAge = -1

    baseNetworkApi.__receivedState = SynchronisedTable()
    baseNetworkApi.__hasReceivedState = false

    function baseNetworkApi:setAge(age)
        self.__localState:setAge(age)
    end

    function baseNetworkApi:checkforUpdates()
        error('NetworkApi must implement a checkForUpdates method')
    end

    function baseNetworkApi:flushUpdates(age, force)
        error('NetworkApi must implement a flushUpdates method')
    end

    function baseNetworkApi:getLocalState()
        return self.__localState
    end
    function baseNetworkApi:getReceivedState()
        return self.__hasReceivedState and self.__receivedState or nil
    end

    return baseNetworkApi
end
