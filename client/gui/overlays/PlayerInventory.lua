local BaseGui = require 'client.gui.BaseGui'
local Inventory = require 'client.gui.components.Inventory'

return function(inventory)
    local playerInventory = BaseGui('inventory')

    playerInventory.inventory = inventory
    playerInventory.menu =
        Inventory {
        styles = {
            marginLeft = '15vmin',
            marginTop = '20vmin',
            marginRight = '15vmin',
            marginBottom = '20vmin'
        },
        inventory = inventory
    }

    return playerInventory
end
