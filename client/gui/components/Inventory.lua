local BaseComponent = require 'client.gui.components.BaseComponent'

local extraDefaultStyles = {
    gapX = '2vmin',
    gapY = '2vmin',
    itemPadding = '1vmin',
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
        local gapX = self:getPixels(self.bakedStyles.gapX, self.bakedBox.w)
        local gapY = self:getPixels(self.bakedStyles.gapY, self.bakedBox.h)
        local itemPadding = self:getPixels(self.bakedStyles.itemPadding, math.min(self.bakedBox.w, self.bakedBox.h))
        local i, j
        for i = 1, numRows do
            for j = 1, self.rowWidth do
                local outer = {
                    x = self.bakedBox.x + itemDim * (j - 1) + gapX / 2,
                    y = self.bakedBox.y + itemDim * (i - 1) + gapY / 2,
                    w = itemDim - gapX,
                    h = itemDim - gapY
                }
                table.insert(
                    self.bakedSquares,
                    {
                        outer = outer,
                        inner = {
                            x = outer.x + itemPadding,
                            y = outer.y + itemPadding,
                            w = outer.w - 2 * itemPadding,
                            h = outer.h - 2 * itemPadding
                        }
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
                square.outer.x,
                square.outer.y,
                0,
                square.outer.w / inventorySquare:getWidth(),
                square.outer.h / inventorySquare:getHeight()
            )
            if self.inventory.stacks[i] then
                self.inventory.stacks[i]:draw(square.inner)
            end
        end
    end

    return inventory
end
