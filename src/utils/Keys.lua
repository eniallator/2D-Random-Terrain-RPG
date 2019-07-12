local keys = {
    state = {},
    recentPressed = {}
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
end

return keys
