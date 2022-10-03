return function(box, inventory, rowWidth, padding, backgroundColour)
    local inventoryComponent = {}

    local inventorySquare = ASSETS.textures.inventory.inventorySquare

    inventoryComponent.box = box
    inventoryComponent.inventory = inventory
    inventoryComponent.rowWidth = rowWidth
    inventoryComponent.backgroundColour = backgroundColour or {r = 0.5, g = 0.5, b = 0.5}
    inventoryComponent.padding = padding or 0

    function inventoryComponent:draw()
        if self.backgroundColour ~= nil then
            love.graphics.setColor(self.backgroundColour.r, self.backgroundColour.g, self.backgroundColour.b)
        end
        love.graphics.setColor(1, 1, 1, 1)
        local i, j
        local numRows = math.ceil(self.inventory.maxStacks / self.rowWidth)

        local itemDim = math.min(self.box.width / self.rowWidth, self.box.height / numRows)

        for i = 1, numRows do
            for j = 1, self.rowWidth do
                if (i - 1) * self.rowWidth + j > self.inventory.maxStacks then
                    break
                end

                local itemBox = {
                    x = self.box.x + itemDim * (j - 1) + self.padding / 2,
                    y = self.box.y + itemDim * (i - 1) + self.padding / 2,
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

    return inventoryComponent
end
