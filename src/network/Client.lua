local socket = require 'socket'
local udp = socket.udp()
local tArgs = {...}

udp:settimeout(0)
udp:setpeername(tArgs[1], tArgs[2])
udp:send("connect")

local running, id, msg, data = true

while running do
    repeat
        msg = love.thread.getChannel("client:status")
        if msg == "stop" then
            -- Send msg to server
            udp:close()
            running = false
        end
    until not msg

    if data then
        if data:match("id:") then
            id = data:match("id:(%d+)")
        else
            love.thread.getChannel("client:received"):push(data)
        end
    end

    data, msg = udp:receive()

    if id then
        repeat
            msg = love.thread.getChannel("client:send"):pop()
            if msg then
                udp:send(id .. ':'.. msg)
            end
        until not msg
    end
end
