local BaseGui = require 'src.gui.BaseGui'
local Minimap = require 'src.gui.components.Minimap'

return function()
    local game = BaseGui()

    local minimapSize = math.min(love.graphics.getDimensions()) / 8
    game.minimap =
        Minimap(
        {
            x = love.graphics.getWidth() - minimapSize,
            y = love.graphics.getHeight() - minimapSize,
            width = minimapSize,
            height = minimapSize
        }
    )

    function game:draw(dt, box, map)
        self.minimap:draw(box, map)
    end

    function game:resize(width, height)
        self.minimap = Minimap()
    end

    return game
end
