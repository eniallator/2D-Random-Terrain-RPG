local ClassesEnum = {
    {label = 'Archer', value = 'archer'},
    {label = 'Cleric', value = 'cleric'},
    {label = 'Mage', value = 'mage'},
    {label = 'Warrior', value = 'warrior'}
}

ClassesEnum.byValue = {}
local i, item
for i, item in ipairs(ClassesEnum) do
    ClassesEnum.byValue[item.value] = i
end
return ClassesEnum
