local SynchronisedTable = require 'common.communication.SynchronisedTable'
local BaseNetworkApi = require 'common.communication.BaseNetworkApi'
local packet = require 'common.communication.Packet'
local socket = require 'socket'
local config = require 'conf'
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname(config.communication.address, config.communication.port)

return function(initialConnectionState)
    local networkApi = BaseNetworkApi()

    networkApi.addressToIdMap = {}
    networkApi.lastHeartbeats = {}
    networkApi.idCounter = 1

    function networkApi:checkForUpdates(age)
        local data, ip, port = udp:receivefrom()
        while data do
            self.__hasReceivedState = true
            self.__receivedState:setAge(age)
            local address = ip .. ':' .. tostring(port)
            local key = self.addressToIdMap[address]
            local headers, payload = packet.deserialise(data)
            if key == nil then
                -- New connection
                key = self.idCounter
                self.idCounter = self.idCounter + 1

                self.__receivedState[key] = {
                    id = key,
                    ip = ip,
                    port = port,
                    clientTickAge = -1,
                    lastServerTickAge = -1,
                    state = {}
                }
                self.__localState[key] = initialConnectionState
                self.addressToIdMap[address] = key
                print('connected id:', key)
            end
            self.lastHeartbeats[key] = age
            self.__receivedState[key].clientTickAge, self.__receivedState[key].lastServerTickAge =
                tonumber(headers.clientTickAge or self.__receivedState[key].clientTickAge),
                tonumber(headers.serverTickAge or self.__receivedState[key].lastServerTickAge)
            self.__receivedState[key].state:deserialiseUpdates(payload, age)
            self.__localState[key]:clearCacheBefore(self.__receivedState[key].lastServerTickAge)

            data, ip, port = udp:receivefrom()
        end
    end

    function networkApi:_checkTimeouts(age)
        local timeouts = {}
        for id, lastAge in pairs(self.lastHeartbeats) do
            if id ~= 1 and age > lastAge + config.communication.timeoutTicks then
                timeouts[#timeouts + 1] = id
            end
        end
        for _, id in ipairs(timeouts) do
            self.addressToIdMap[self.__receivedState[id].ip .. ':' .. tostring(self.__receivedState[id].port)] = nil
            self.lastHeartbeats[id] = nil
            self.__receivedState[id]:clear()
            self.__receivedState[id] = nil
            print('Timed out id', id)
        end
    end

    function networkApi:flushUpdates(age)
        self:_checkTimeouts(age)
        for id, connection in self.__receivedState:subTablePairs() do
            udp:sendto(
                packet.serialise(
                    {id = connection.id, serverTickAge = age, lastClientTickAge = connection.clientTickAge},
                    self.__localState[id]:serialiseUpdates(connection.lastServerTickAge - 1, nil)
                ),
                connection.ip,
                connection.port
            )
        end
    end

    return networkApi
end
