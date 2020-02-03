local socket = require 'socket'
local udp = socket.udp()

udp:settimeout(0)
udp:setsockname('localhost', 3000)

local gameTable = {}
local id = 1

while true do
    local data, ip, port = udp:receivefrom()
    if data then
        if data == "connect" then
            gameTable[tostring(id)] = {
                ip = ip,
                port = port,
                x = math.floor(math.random() * 800),
                y = math.floor(math.random() * 600)
            }
            udp:sendto("id:" .. tostring(id), ip, port)
            print("connected id:", id)
            id = id + 1
        else
            local key
            key, data = data:match("(%d+):(.*)")
            if data == "disconnect" then
                gameTable[key] = nil
            elseif data == "s" then
                gameTable[key].y = gameTable[key].y + 1
            elseif data == "w" then
                gameTable[key].y = gameTable[key].y - 1
            elseif data == "d" then
                gameTable[key].x = gameTable[key].x + 1
            elseif data == "a" then
                gameTable[key].x = gameTable[key].x - 1
            end
        end

        local msg = ''
        for _, pos in pairs(gameTable) do
            if msg ~= '' then
                msg = msg .. 'p'
            end
            msg = msg .. 'x' .. pos.x .. 'y' .. pos.y
        end 

        print(msg)
        for id, state in pairs(gameTable) do
            udp:sendto(msg, state.ip, state.port)
        end
    end
end
