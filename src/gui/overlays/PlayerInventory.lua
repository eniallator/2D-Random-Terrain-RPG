local BaseGui = require 'src.gui.BaseGui'
local Grid = require 'src.gui.Grid'

return function(inventory)
    local playerInventory = BaseGui()

    playerInventory.menu = Grid()
    playerInventory.inventory = inventory

    playerInventory.menu:addComponent(
        'inventory',
        {value = 1},
        {value = 1},
        {
            playerInventory.inventory,
            9,
            math.min(love.graphics.getDimensions()) / 100,
            {r = 0.7, g = 0.7, b = 0.7}
        }
    )

    function playerInventory:resize(width, height)
        local minDim = math.min(width, height)
        self.menu:setPadding(minDim / 40, minDim / 60)
        -- local border = {
        --     x = width / 3,
        --     y = height * 7 / 16
        -- }
        -- self.menu:init(border.x, border.y * 1.5, width - border.x * 2, height - border.y * 2)

        local dim = {
            width = width / 1.5,
            height = height / 1.4
        }
        self.menu:init(width / 2 - dim.width / 2, height / 2 - dim.height / 2, dim.width, dim.height)
    end

    function playerInventory:update(state)
        self:updateMenu(self.menu, state)
    end

    function playerInventory:draw(dt)
        self:drawMenu(self.menu, dt)
    end

    playerInventory:resize(love.graphics.getDimensions())

    return playerInventory
end
