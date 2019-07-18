local config = require 'conf'

return function(xOrTarget, y)
    local camera = {}

    camera.following = not y
    if camera.following then
        camera.target = xOrTarget
    else
        camera.pos = {x = xOrTarget, y = y}
    end
    camera.scale = config.camera.initialZoom

    function camera:setTarget(target)
        self.pos = nil
        self.target = target
        self.following = true
    end

    function camera:setPos(x, y)
        self.target = nil
        self.pos = {x = x, y = y}
        self.following = false
    end

    function camera:setScale(scale)
        self.scale = scale
    end

    function camera:getViewBox()
        local dim = {
            width = love.graphics.getWidth() / self.scale,
            height = love.graphics.getHeight() / self.scale
        }
        if self.target ~= nil then
            return {
                x = self.target.drawPos.x,
                y = self.target.drawPos.y - self.target.sprite.dim.height / 2,
                width = dim.width,
                height = dim.height
            }
        else
            return {
                x = self.pos.x,
                y = self.pos.y,
                width = dim.width,
                height = dim.height
            }
        end
    end

    return camera
end
