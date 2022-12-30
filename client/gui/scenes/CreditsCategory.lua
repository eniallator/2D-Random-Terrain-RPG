local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.components.Grid'
local Label = require 'client.gui.components.Label'
local Credits = require 'client.gui.components.Credits'
local Button = require 'client.gui.components.Button'
local creditsData = require 'credits'

return function(state)
    local creditsCategory = BaseGui()

    creditsCategory.menu =
        Grid {
        styles = {
            gapY = '2%',
            marginLeft = '12.5%',
            marginTop = '10%',
            marginRight = '12.5%',
            marginBottom = '10%'
        },
        children = {
            Label {text = state.creditsCategory .. ' credits'},
            Credits {data = creditsData[state.creditsCategory], yWeight = 4},
            Button {
                text = 'Back',
                onClick = function(state)
                    state.creditsCategory = nil
                    state.scene = 'credits'
                end
            }
        }
    }

    return creditsCategory
end
