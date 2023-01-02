local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.components.Grid'
local Label = require 'client.gui.components.Label'
local Button = require 'client.gui.components.Button'
local CharacterDisplay = require 'client.gui.components.CharacterDisplay'

local ClassesEnum = require 'common.types.ClassesEnum'

return function(state)
    local mainMenu = BaseGui()

    mainMenu.menu =
        Grid {
        styles = {
            marginLeft = '20%',
            marginTop = '10%',
            marginRight = '20%',
            marginBottom = '10%'
        },
        children = {
            Label {
                styles = {background = {r = 0.3, g = 0.3, b = 0.3}, font = 'Psilly'},
                text = state.nickname
            },
            CharacterDisplay {spriteData = state.spriteData, yWeight = 4},
            Label {
                styles = {background = {r = 0.3, g = 0.3, b = 0.3}},
                text = state.class == nil and 'No class selected' or ClassesEnum[ClassesEnum.byValue[state.class]].label
            },
            Button {
                text = 'Select Character',
                onClick = function(state)
                    state.scene = 'characterSelect'
                end
            },
            Grid {
                columns = 2,
                children = {
                    Button {
                        text = 'Host',
                        onClick = function(state)
                            state.scene = 'game'
                        end,
                        disabled = function(state)
                            return state.class == nil
                        end
                    },
                    Button {
                        text = 'Connect to a host',
                        onClick = function(state)
                            state.scene = 'multiplayer'
                        end,
                        disabled = function(state)
                            return state.class == nil
                        end
                    }
                }
            },
            Button {
                text = 'Credits',
                onClick = function(state)
                    state.scene = 'credits'
                end
            }
        }
    }

    return mainMenu
end
