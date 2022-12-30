local BaseComponent = require 'client.gui.components.BaseComponent'

local extraDefaultStyles = {
    gapX = 10,
    gapY = 10,
    background = {r = 0.7, g = 0.7, b = 0.7, a = 1}
}

return function(args)
    local inventory = BaseComponent(args, extraDefaultStyles)

    local inventorySquare = ASSETS.textures.inventory.inventorySquare

    inventory.inventory = args.inventory
    inventory.rowWidth = args.rowWidth or 9

    function inventory:draw()
        if self.bakedStyles.background then
            love.graphics.setColor(
                self.bakedStyles.background.r,
                self.bakedStyles.background.g,
                self.bakedStyles.background.b,
                self.bakedStyles.background.a
            )
        end
        local numRows = math.ceil(self.inventory.maxStacks / self.rowWidth)

        local itemDim = math.min(self.bakedBox.w / self.rowWidth, self.bakedBox.h / numRows)

        local i, j
        for i = 1, numRows do
            for j = 1, self.rowWidth do
                if (i - 1) * self.rowWidth + j > self.inventory.maxStacks then
                    break
                end

                local itemBox = {
                    x = self.bakedBox.x + itemDim * (j - 1) + self.padding / 2,
                    y = self.bakedBox.y + itemDim * (i - 1) + self.padding / 2,
                    width = itemDim - self.padding,
                    height = itemDim - self.padding
                }
                love.graphics.draw(
                    inventorySquare,
                    itemBox.x,
                    itemBox.y,
                    0,
                    itemBox.width / inventorySquare:getWidth(),
                    itemBox.height / inventorySquare:getHeight()
                )
                if i <= #self.inventory.stacks then
                    self.inventory.stacks[i].draw(itemBox)
                end
            end
        end
    end

    return inventory
end
