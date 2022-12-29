local SynchronisedTable = require 'common.communication.SynchronisedTable'
local BaseNetworkApi = require 'common.communication.BaseNetworkApi'
local packet = require 'common.communication.Packet'
local socket = require 'socket'
local cfg = require 'conf'

return function(initialLocalState)
    local networkApi = BaseNetworkApi(initialLocalState)

    networkApi.serverTickAge = -1
    networkApi.serverLastClientTickAge = -1

    function networkApi:checkForUpdates(age)
        if self.udp == nil then
            return
        end
        local data, msg = self.udp:receive()
        if data then
            self.lastReceived = age
        end
        while data do
            local headers, payload = packet.deserialise(data)
            self.id, self.serverTickAge, self.serverLastClientTickAge =
                headers.id,
                tonumber(headers.serverTickAge),
                tonumber(headers.lastClientTickAge)
            self.__receivedState:deserialiseUpdates(payload)
            self.__localState:clearCacheBefore(self.serverLastClientTickAge)
            self.__hasReceivedState = true
            data, msg = self.udp:receive()
        end
    end

    function networkApi:connect(address, port)
        if self.udp == nil then
            self.udp = socket.udp()
            self.udp:settimeout(0)
            self.udp:setpeername(address, port)
        else
            error('Tried making a new connection when already connected!')
        end
    end

    function networkApi:disconnect()
        if self.udp ~= nil then
            -- TODO: Send disconnect message
            -- self.udp:send()
            self.udp:close()
            self.udp = nil
        end
    end

    function networkApi:flushUpdates(age, force)
        if self.udp == nil then
            return
        end
        local headers = {clientTickAge = age, serverTickAge = self.serverTickAge}
        local payload = self.__localState:serialiseUpdates(self.serverLastClientTickAge - 1, force)
        -- print('CLIENT sent:', payload)
        self.udp:send(packet.serialise(headers, payload))
    end

    networkApi:flushUpdates(0, true)

    return networkApi
end
