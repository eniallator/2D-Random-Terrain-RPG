local BaseComponent = require 'client.gui.components.BaseComponent'

local extraDefaultStyles = {
    gapX = 10,
    gapY = 10,
    background = false
}

return function(args)
    local inventory = BaseComponent(args, extraDefaultStyles)

    local inventorySquare = ASSETS.textures.inventory.inventorySquare

    inventory.inventory = args.inventory
    inventory.rowWidth = args.rowWidth or 9

    local oldBake = inventory.bake
    function inventory:bake(x, y, w, h)
        oldBake(self, x, y, w, h)
        self.bakedSquares = {}
        local numRows = math.ceil(self.inventory.maxStacks / self.rowWidth)
        local itemDim = math.min(self.bakedBox.w / self.rowWidth, self.bakedBox.h / numRows)
        local i, j
        for i = 1, numRows do
            for j = 1, self.rowWidth do
                table.insert(
                    self.bakedSquares,
                    {
                        x = self.bakedBox.x + itemDim * (j - 1) + self.bakedStyles.gapX / 2,
                        y = self.bakedBox.y + itemDim * (i - 1) + self.bakedStyles.gapY / 2,
                        w = itemDim - self.bakedStyles.gapX,
                        h = itemDim - self.bakedStyles.gapY
                    }
                )
            end
        end
    end

    function inventory:draw()
        local background = self:getStyle('background')
        if background then
            love.graphics.setColor(background.r, background.g, background.b, background.a)
        end

        local i, square
        for i, square in ipairs(self.bakedSquares) do
            love.graphics.draw(
                inventorySquare,
                square.x,
                square.y,
                0,
                square.w / inventorySquare:getWidth(),
                square.h / inventorySquare:getHeight()
            )
            if self.inventory.stacks[i] then
                self.inventory.stacks[i]:draw(square)
            end
        end
    end

    return inventory
end
