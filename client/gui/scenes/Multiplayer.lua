local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.components.Grid'
local Label = require 'client.gui.components.Label'
local Button = require 'client.gui.components.Button'
local TextInput = require 'client.gui.components.TextInput'

return function(state)
    local multiplayer = BaseGui()

    state.multiplayer = {address = '', port = ''}

    multiplayer.menu =
        Grid {
        styles = {
            marginLeft = '20%',
            marginTop = '10%',
            marginRight = '20%',
            marginBottom = '10%'
        },
        columns = 2,
        children = {
            Label {
                text = "Enter the server's address:"
            },
            TextInput {
                outputTbl = state.multiplayer,
                outputTblKey = 'address'
            },
            Label {
                text = 'Port:'
            },
            TextInput {
                outputTbl = state.multiplayer,
                outputTblKey = 'port'
            },
            Button {
                text = 'Back',
                onClick = function(state)
                    state.multiplayer = nil
                    state.scene = 'mainMenu'
                end
            },
            Button {
                text = 'Connect',
                onClick = function(state)
                    state.scene = 'game'
                end,
                disabled = function(state)
                    return state.multiplayer ~= nil and #state.multiplayer.address == 0 and #state.multiplayer.port == 0
                end
            }
        }
    }

    return multiplayer
end
