local NetworkApi = require 'client.communication.NetworkApi'
local GameLoopController = require 'common.GameLoopController'

local dim = {}
dim.width, dim.height = love.graphics.getDimensions()

-- CLIENT GAME LOGIC HAPPENING ON MAIN THREAD
--   so no need to define own engine logic, since it can use Love2D's engine
return function(cfg)
    local main =
        GameLoopController(
        NetworkApi(
            {
                pos = {
                    x = dim.width * math.random(),
                    y = dim.height * math.random()
                },
                colour = {
                    r = math.random(),
                    g = math.random(),
                    b = math.random()
                }
            }
        ),
        cfg
    )

    sceneManager =
        SceneManager(
        {
            scene = 'mainMenu',
            spriteData = {
                hair = {r = 210 / 255, g = 125 / 255, b = 44 / 255},
                eyes = {r = 0, g = 0, b = 0}
            },
            nickname = 'player'
        }
    )

    function main:updateTick(localState, receivedState)
        -- All client-side game logic happening here
        map:update(localState, receivedState)
        entity:update(localState, receivedState)
        projectile:update(localState, receivedState)
        camera:update(localState, receivedState)

        inputs:clearCache()
    end

    function main:drawWithDt(localState, receivedState, dt)
        -- All client-side drawing happening here
        local box = camera:getViewBox()

        map:draw(localState, receivedState, dt, box)
        entity:draw(localState, receivedState, dt, box)
        projectile:draw(localState, receivedState, dt, box)
    end

    return main
end
