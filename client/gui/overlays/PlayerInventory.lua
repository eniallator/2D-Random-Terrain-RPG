local BaseGui = require 'client.gui.BaseGui'
local Inventory = require 'client.gui.components.Inventory'

return function(inventory)
    local playerInventory = BaseGui()

    playerInventory.inventory = inventory
    playerInventory.menu =
        Inventory {
        styles = {
            marginLeft = '16%',
            marginTop = '14%',
            marginRight = '16%',
            marginBottom = '14%'
        },
        inventory = inventory
    }

    return playerInventory
end
