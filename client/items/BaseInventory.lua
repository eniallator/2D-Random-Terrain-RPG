return function(maxStacks)
    local baseInventory = {}

    baseInventory.maxStacks = maxStacks
    baseInventory.stacks = {}

    function baseInventory:addStack(stack)
        if index < 1 or index > self.maxStacks or self.stacks[index] ~= nil then
            return nil
        end

        self.stacks[#self.stacks + 1] = stack
    end

    function baseInventory:removeStack(index)
        local stack = self.stacks[index]
        self.stacks[index] = nil
        return stack
    end

    return baseInventory
end
