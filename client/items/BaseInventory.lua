return function(maxStacks)
    local baseInventory = {}

    baseInventory.maxStacks = maxStacks
    baseInventory.stacks = {}

    function baseInventory:addStack(stack)
        local lastIndex, i = 0
        for i in pairs(self.stacks) do
            if i - 1 == lastIndex then
                lastIndex = i
            else
                break
            end
        end
        if lastIndex < self.maxStacks then
            self.stacks[lastIndex + 1] = stack
        end
    end

    function baseInventory:removeStack(index)
        local stack = self.stacks[index]
        self.stacks[index] = nil
        return stack
    end

    return baseInventory
end
