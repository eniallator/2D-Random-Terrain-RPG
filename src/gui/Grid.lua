local Button = require 'src.gui.Button'
local CharacterDisplay = require 'src.gui.CharacterDisplay'

local components = {button = Button, characterDisplay = CharacterDisplay}

return function()
    local grid = {}

    grid.componentData = {}
    grid.weights = {x = {}, y = {}}
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
                        self.weights.x[x.value] = x.weight or self.weights.x[x.value]
                        self.weights.y[y.value] = y.weight or self.weights.y[y.value]
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

    local function summedOffsets(tbl)
        local sumTbl = {}
        local sum = 0
        for key, val in pairs(tbl) do
            sumTbl[key] = sum
            sum = sum + val
        end
        return sumTbl
    end

    local function sumTbl(tbl)
        local sum = 0
        for key, val in pairs(tbl) do
            sum = sum + val
        end
        return sum
    end

    function grid:init(x, y, width, height)
        self.initialisedComponents = {}

        local totalWeights = {
            x = sumTbl(self.weights.x),
            y = sumTbl(self.weights.y)
        }
        local weightOffsets = {
            x = summedOffsets(self.weights.x),
            y = summedOffsets(self.weights.y)
        }

        for _, row in ipairs(self.componentData) do
            for _, data in ipairs(row) do
                local box = {
                    x = x + weightOffsets.x[data.x] / totalWeights.x * width + self.padding.x / 2,
                    y = y + weightOffsets.y[row.y] / totalWeights.y * width + self.padding.y / 2,
                    width = self.weights.x[data.x] / totalWeights.x * width - self.padding.x,
                    height = self.weights.y[row.y] / totalWeights.y * height - self.padding.y
                }
                local component = components[data.type](box, unpack(data.args))
                table.insert(self.initialisedComponents, component)
            end
        end
    end

    function grid:getComponents()
        return self.initialisedComponents
    end

    return grid
end
