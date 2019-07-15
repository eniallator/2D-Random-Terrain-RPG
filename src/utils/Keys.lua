love.keyboard.setKeyRepeat(true)

local keys = {
    state = {},
    recentPressed = {},
    textString = ''
}

local function updateKeyState(key, newMode)
    keys.currKey = newMode and key or keys.currKey ~= key and keys.currKey
    keys.state[key] = newMode
end

keys.updateRecentPressed = function()
    keys.textInput = nil
    keys.recentPressed = {}
end

function love.keypressed(key)
    if key == 'backspace' and #keys.textString > 0 then
        keys.textString = keys.textString:sub(1, #keys.textString - 1)
    end

    if not keys.state[key] then
        keys.recentPressed[key] = true
    end
    updateKeyState(key, true)
end

function love.keyreleased(key)
    updateKeyState(key, false)
end

function love.textinput(text)
    keys.textInput = text
    keys.textString = keys.textString .. text
end

return keys
