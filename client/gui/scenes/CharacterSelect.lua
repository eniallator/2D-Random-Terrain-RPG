local BaseGui = require 'client.gui.BaseGui'
local Grid = require 'client.gui.components.Grid'
local Label = require 'client.gui.components.Label'
local Button = require 'client.gui.components.Button'
local TextInput = require 'client.gui.components.TextInput'
local CharacterDisplay = require 'client.gui.components.CharacterDisplay'

local ClassesEnum = require 'common.types.ClassesEnum'

return function(state)
    local characterSelect = BaseGui()

    characterSelect.menu =
        Grid {
        styles = {
            gapY = '2%',
            marginLeft = '12.5%',
            marginTop = '10%',
            marginRight = '12.5%',
            marginBottom = '10%'
        },
        children = {
            TextInput {outputTbl = state, outputTblKey = 'nickname'},
            Grid {
                styles = {
                    marginTop = '1%',
                    marginBottom = '1%'
                },
                columns = 3,
                yWeight = 4,
                children = {
                    Button {
                        text = 'Eye Colour',
                        onClick = function(state)
                            state.scene = 'colourPicker'
                            state.selectedColourLabel = 'Eye Colour'
                            state.selectedColourTbl = state.spriteData.eyes
                        end
                    },
                    CharacterDisplay {spriteData = state.spriteData},
                    Button {
                        text = 'Hair Colour',
                        onClick = function(state)
                            state.scene = 'colourPicker'
                            state.selectedColourLabel = 'Hair Colour'
                            state.selectedColourTbl = state.spriteData.hair
                        end
                    },
                    Button {
                        text = '<',
                        onClick = function(state)
                            local index
                            if state.class == nil then
                                index = #ClassesEnum
                            else
                                index = (ClassesEnum.byValue[state.class] - 2) % #ClassesEnum + 1
                            end
                            state.class = ClassesEnum[index].value
                        end
                    },
                    Label {
                        text = function(state)
                            return state.class == nil and 'No class selected' or
                                ClassesEnum[ClassesEnum.byValue[state.class]].label
                        end
                    },
                    Button {
                        text = '>',
                        onClick = function()
                            local index
                            if state.class == nil then
                                index = 1
                            else
                                index = ClassesEnum.byValue[state.class] % #ClassesEnum + 1
                            end
                            state.class = ClassesEnum[index].value
                        end
                    }
                }
            },
            Button {
                text = 'Back',
                onClick = function(state)
                    state.scene = 'mainMenu'
                end
            }
        }
    }

    return characterSelect
end
