local classes = {
    indices = {},
    {name = 'Archer', init = require 'client.class.Archer'},
    {name = 'Cleric', init = require 'client.class.Cleric'},
    {name = 'Mage', init = require 'client.class.Mage'},
    {name = 'Warrior', init = require 'client.class.Warrior'}
}

for k, v in ipairs(classes) do
    classes.indices[v.name] = k
end

return classes
