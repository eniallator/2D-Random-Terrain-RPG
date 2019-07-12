local config = require 'conf'

return function(xOrTarget, y)
    local camera = {}

    if y ~= nil then
        camera.pos = {x = xOrTarget or 0, y = y or 0}
    else
        camera.targetPos = xOrTarget
    end
    camera.scale = config.initialScale

    function camera:setTarget(targetPos)
        self.targetPos = targetPos
    end

    function camera:setScale(scale)
        self.scale = scale
    end

    function camera:getViewBox()
        local centrePos = self.pos
        if self.targetPos ~= nil then
            centrePos = self.targetPos
        end

        local dim = {
            width = love.graphics.getWidth() / self.scale,
            height = love.graphics.getHeight() / self.scale
        }
        return {
            x = centrePos.x,
            y = centrePos.y,
            width = dim.width,
            height = dim.height
        }
    end

    return camera
end
