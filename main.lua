local development = true

if development then
    serialise = require 'src.development.serialise'
end

local sprite = require 'src.sprite'

local test

function love.load()
    test = sprite('assets/textures/icons/game-icon.png', 16, 16)
    print(serialise(test), test:getFrameQuad())
end

function love.resize(w, h)
end

function love.update()
end

function love.draw(dt)
    love.graphics.draw(test:getFrameQuad(), 10, 10)
end
