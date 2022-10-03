local config = require 'conf'
if config.development then
    serialise = require 'common.development.Serialise'
end

local Server, server = require 'server.Main'

server = Server()

local lastTicked = os.clock()

while true do
    local currTime = os.clock()
    local dt = currTime - lastTicked
    lastTicked = currTime

    server:update(dt)
end
