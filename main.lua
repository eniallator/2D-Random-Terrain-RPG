local config = require 'myConf'

require 'src.engine'

if config.development then
    serialise = require 'src.development.serialise'
end

local sprite, engine

local test

function love.load()
    sprite = require 'src.sprite'
    engine = require 'src.engine'
    test = sprite('assets/textures/icons/game-icon.png', 32, 32)
    print(serialise(test), test:getFrameQuad())
end

function love.resize(w, h)
end

function love.update()
    --[[
        1. Get inputs
        2. Update values
    ]]
end

function love.draw(dt)
    --[[
        1. Draw floor tiles
        2. Draw sprites/tiles above the floor from the back to the front
        3. Draw overlays/UIs
    ]]
    love.graphics.draw(test.spriteSheet, test:getFrameQuad(), 10, 10)
    test:nextFrame()
end
