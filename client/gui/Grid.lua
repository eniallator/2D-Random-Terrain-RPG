local OrderedTable = require 'common.types.OrderedTable'

local components = {
    button = require 'client.gui.components.Button',
    characterDisplay = require 'client.gui.components.CharacterDisplay',
    textInput = require 'client.gui.components.TextInput',
    label = require 'client.gui.components.Label',
    credits = require 'client.gui.components.Credits',
    inventory = require 'client.gui.components.Inventory',
    colourPicker = require 'client.gui.components.ColourPicker'
}

return function()
    local grid = {}

    grid.componentData = {}
    grid.weights = {x = OrderedTable(), y = OrderedTable()}
    grid.initialisedComponents = {}
    grid.padding = {x = 0, y = 0}

    function grid:addComponent(componentType, x, y, args)
        local i, j
        for i = 1, #self.componentData + 1 do
            if i > #self.componentData or y.value <= self.componentData[i].y then
                local row = self.componentData[i]
                if i > #self.componentData or y.value < self.componentData[i].y then
                    row = {y = y.value}
                    table.insert(self.componentData, i, row)
                end

                for j = 1, #row + 1 do
                    if j > #row or x.value < row[j].x then
                        data = {x = x.value, type = componentType, args = args}
                        table.insert(row, j, data)
                        self.weights.x:add(x.value, x.weight or self.weights.x:get(x.value) or 1)
                        self.weights.y:add(y.value, y.weight or self.weights.y:get(y.value) or 1)
                        return
                    end
                end
            end
        end
    end

    function grid:setPadding(x, y)
        self.padding.x = x
        self.padding.y = y or x
    end

    local function runningTotalReducer(acc, val, priority)
        acc.tbl[priority] = acc.total
        acc.total = acc.total + val
        return acc
    end

    function grid:bakeComponents(x, y, width, height)
        self.initialisedComponents = {}

        local runningWeightSums = {}
        local totalWeights = {}

        local xWeights = self.weights.x:reduce(runningTotalReducer, {total = 0, tbl = {}})
        local yWeights = self.weights.y:reduce(runningTotalReducer, {total = 0, tbl = {}})

        runningWeightSums.x, totalWeights.x = xWeights.tbl, xWeights.total
        runningWeightSums.y, totalWeights.y = yWeights.tbl, yWeights.total

        local _, row, data
        for _, row in ipairs(self.componentData) do
            for _, data in ipairs(row) do
                local box = {
                    x = x + runningWeightSums.x[data.x] / totalWeights.x * width + self.padding.x / 2,
                    y = y + runningWeightSums.y[row.y] / totalWeights.y * height + self.padding.y / 2,
                    width = self.weights.x:get(data.x) / totalWeights.x * width - self.padding.x,
                    height = self.weights.y:get(row.y) / totalWeights.y * height - self.padding.y
                }
                local component
                if type(data.args) == 'table' then
                    component = components[data.type](box, unpack(data.args))
                else
                    component = components[data.type](box, data.args)
                end
                table.insert(self.initialisedComponents, component)
            end
        end
    end

    function grid:getComponents()
        return self.initialisedComponents
    end

    return grid
end
