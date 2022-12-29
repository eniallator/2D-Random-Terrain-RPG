return function()
    local orderedTable = {}

    orderedTable.data = {}

    function orderedTable:add(priority, data)
        if type(priority) ~= 'number' then
            return
        end
        local i = 1
        while self.data[i] and self.data[i].priority < priority do
            i = i + 1
        end
        if self.data[i] and self.data[i].priority == priority then
            self.data[i].data = data
        else
            table.insert(self.data, i, {priority = priority, data = data})
        end
    end

    function orderedTable:get(priority)
        local _, entry
        for _, entry in ipairs(self.data) do
            if entry.priority == priority then
                return entry.data
            end
        end
    end

    function orderedTable:length()
        return #self.data
    end

    function orderedTable:reduce(func, initialValue)
        local accumulator, i = type(initialValue) ~= 'nil' and initialValue or self.data[1] and self.data[1].value
        for i = type(initialValue) ~= 'nil' and 1 or 2, #self.data do
            accumulator = func(accumulator, self.data[i].data, self.data[i].priority)
        end
        return accumulator
    end

    function orderedTable:iterate(func, ascending)
        if type(ascending) == 'boolean' and not ascending then
            local i
            for i = #self.data, 1, -1 do
                func(self.data[i].data, self.data[i].priority)
            end
        else
            local _, entry
            for _, entry in ipairs(self.data) do
                func(entry.data, entry.priority)
            end
        end
    end

    return orderedTable
end
