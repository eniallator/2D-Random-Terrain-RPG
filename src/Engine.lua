local config = require 'conf'
MOUSE = require 'src.utils.Mouse'
KEYS = require 'src.utils.Keys'

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
            dt = dt + love.timer.step()
        end

        if love.update then
            while dt > 1 / config.tps do
                love.update()
                MOUSE.updateClicked()
                KEYS.textInput = nil
                dt = dt - (1 / config.tps)
            end
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            if love.draw then
                love.draw(dt * config.tps)
            end

            love.graphics.present()
        end

        if love.timer then
            love.timer.sleep(0.001)
        end
    end
end
