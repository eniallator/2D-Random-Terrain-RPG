local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.components.Grid'
local Button = require 'client.gui.components.Button'
local creditsData = require 'credits'

return function(state)
    local credits = BaseGui()
    credits.menu =
        Grid {
        styles = {
            gapY = '2%',
            marginLeft = '12.5%',
            marginTop = '10%',
            marginRight = '12.5%',
            marginBottom = '10%'
        },
        children = {
            Button {
                yWeight = 2,
                text = 'Art',
                onClick = function(state)
                    state.creditsCategory = 'Art'
                    state.scene = 'creditsCategory'
                end
            },
            Button {
                yWeight = 2,
                text = 'Programming',
                onClick = function(state)
                    state.creditsCategory = 'Programming'
                    state.scene = 'creditsCategory'
                end
            },
            Button {
                text = 'Back',
                onClick = function(state)
                    state.scene = 'mainMenu'
                end
            }
        }
    }

    return credits
end
