local keys = {
    state = {}
}

local function updateKeyState(key, newMode)
    keys.currKey = newMode and key or keys.currKey ~= key and keys.currKey
    keys.state[key] = newMode
end

function love.keypressed(key)
    updateKeyState(key, true)
end

function love.keyreleased(key)
    updateKeyState(key, false)
end

function love.textinput(text)
    keys.textInput = text
end

return keys
