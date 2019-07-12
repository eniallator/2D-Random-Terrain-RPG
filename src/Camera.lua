local config = require 'conf'

return function(xOrTarget, y)
    local camera = {}

    camera.following = not y
    camera.pos = camera.following and xOrTarget or {x = xOrTarget, y = y}
    camera.scale = config.camera.initialZoom

    function camera:setTarget(targetPos)
        self.following = true
        self.pos = targetPos
    end

    function camera:setPos(x, y)
        self.following = false
        self.pos = {x = x, y = y}
    end

    function camera:setScale(scale)
        self.scale = scale
    end

    function camera:getViewBox()
        local dim = {
            width = love.graphics.getWidth() / self.scale,
            height = love.graphics.getHeight() / self.scale
        }
        return {
            x = self.pos.x,
            y = self.pos.y,
            width = dim.width,
            height = dim.height
        }
    end

    return camera
end
