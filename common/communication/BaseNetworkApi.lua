local VersionTable = require 'common.communication.VersionTable'

return function(initialLocalState)
    local baseNetworkApi = {}

    baseNetworkApi.__localState = VersionTable(initialLocalState)
    baseNetworkApi.__lastAge = -1

    baseNetworkApi.__receivedState = VersionTable()
    baseNetworkApi.__hasReceivedState = false

    function baseNetworkApi:setVersion(age)
        self.__localState:setVersion(age)
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
