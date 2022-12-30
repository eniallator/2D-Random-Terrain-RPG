local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.components.Grid'
local Label = require 'client.gui.components.Label'
local Button = require 'client.gui.components.Button'
local ColourPicker = require 'client.gui.components.ColourPicker'

return function(state)
    local colourPicker = BaseGui()

    colourPicker.menu =
        Grid {
        styles = {
            gapY = '2%',
            marginLeft = '12.5%',
            marginTop = '10%',
            marginRight = '12.5%',
            marginBottom = '10%'
        },
        children = {
            Label {text = state.selectedColourLabel},
            ColourPicker {outputTbl = state.selectedColourTbl, yWeight = 5},
            Label {styles = {background = state.selectedColourTbl}},
            Button {
                text = 'Save',
                onClick = function(state)
                    state.selectedColourLabel = nil
                    state.selectedColourTbl = nil
                    state.scene = 'characterSelect'
                end
            }
        }
    }

    return colourPicker
end
