local development = true

if development then
    serialise = require 'src.development.serialise'
end

local sprite = require 'src.sprite'

local test

function love.load()
    test = sprite('assets/textures/icons/game-icon.png', 32, 32)
    print(serialise(test), test:getFrameQuad())
end

function love.resize(w, h)
end

function love.update()
end

function love.draw()
    love.graphics.draw(test.spriteSheet, test:getFrameQuad(), 10, 10)
    test:nextFrame()
end

-- Modifying from: https://bitbucket.org/rude/love/src/default/src/scripts/boot.lua#lines-578:619
function love.run()
    if love.load then
        love.load(love.arg.parseGameArguments(arg), arg)
    end

    if love.timer then
        love.timer.step()
    end

    local dt = 0

    return function()
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == 'quit' then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end

        if love.timer then
            dt = love.timer.step()
        end

        if love.update then
            love.update(dt)
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            if love.draw then
                love.draw()
            end

            love.graphics.present()
        end

        if love.timer then
            love.timer.sleep(0.001)
        end
    end
end
