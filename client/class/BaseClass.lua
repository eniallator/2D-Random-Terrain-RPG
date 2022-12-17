return function()
    local baseClass = {}

    baseClass.abilityList = {}

    function baseClass:addAbility(func, meta)
        table.insert(self.abilityList, {func = func, meta = meta})
    end

    function baseClass:useAbility(id, args)
        if self.abilityList[id] then
            self.abilityList[id].func(self.abilityList[id].meta, args)
        end
    end

    return baseClass
end
