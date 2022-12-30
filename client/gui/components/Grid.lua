local BaseComponent = require 'client.gui.components.BaseComponent'

local extraDefaultStyles = {
    gapX = '2vmin',
    gapY = '2vmin'
}

return function(args)
    local grid = BaseComponent(args, extraDefaultStyles)
    grid.columns = args.columns or 1

    function grid:computeWeights()
        local computedTotalChildXWeight = 0
        self.computedTotalChildYWeight = 0
        self.computedRowXWeights = {0}
        self.computedRowYWeights = {0}
        if self.children then
            local i, child
            for i, child in ipairs(self.children) do
                child:computeWeights()
                local rowIndex = math.ceil(i / self.columns)
                self.computedRowXWeights[rowIndex] = self.computedRowXWeights[rowIndex] + child.computedXWeight
                self.computedRowYWeights[rowIndex] = math.max(self.computedRowYWeights[rowIndex], child.computedYWeight)
                if i % self.columns == 0 then
                    if i < #self.children then
                        self.computedRowXWeights[rowIndex + 1] = 0
                        self.computedRowYWeights[rowIndex + 1] = 0
                    end
                    computedTotalChildXWeight = math.ceil(computedTotalChildXWeight, self.computedRowXWeights[rowIndex])
                    self.computedTotalChildYWeight = self.computedTotalChildYWeight + self.computedRowYWeights[rowIndex]
                end
            end
            if #self.children % self.columns ~= 0 then
                local lastRowIndex = math.ceil(#self.children / self.columns)
                computedTotalChildXWeight = math.ceil(computedTotalChildXWeight, self.computedRowXWeights[lastRowIndex])
                self.computedTotalChildYWeight = self.computedTotalChildYWeight + self.computedRowYWeights[lastRowIndex]
            end
        end
        self.computedXWeight = self.xWeight or math.max(1, computedTotalChildXWeight)
        self.computedYWeight = self.yWeight or math.max(1, self.computedTotalChildYWeight)
    end

    function grid:bakeChildren(x, y, w, h)
        local lastRowIndex = math.ceil(#self.children / self.columns)
        local currXWeight, currYWeight, i, child = 0, 0
        local gapX = self:getPixels(self.bakedStyles.gapX, w)
        local gapY = self:getPixels(self.bakedStyles.gapY, h)
        for i, child in ipairs(self.children) do
            local rowIndex = math.ceil(i / self.columns)
            local xOffset = (i % self.columns == 1 and 0 or gapX / 2)
            local yOffset = (rowIndex == 1 and 0 or gapY / 2)
            child:bake(
                x + currXWeight / self.computedRowXWeights[rowIndex] * w + xOffset,
                y + currYWeight / self.computedTotalChildYWeight * h + yOffset,
                child.computedXWeight / self.computedRowXWeights[rowIndex] * w -
                    (i % self.columns == 0 and xOffset or gapX),
                self.computedRowYWeights[rowIndex] / self.computedTotalChildYWeight * h -
                    (rowIndex == lastRowIndex and yOffset or gapY)
            )
            if i % self.columns == 0 then
                currXWeight = 0
                currYWeight = currYWeight + self.computedRowYWeights[rowIndex]
            else
                currXWeight = currXWeight + child.computedXWeight
            end
        end
    end

    return grid
end
