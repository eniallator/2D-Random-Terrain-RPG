local function getRelativeCoords(box, pos)
    if (box.x <= pos.x and pos.x < box.x + box.width) and
            (box.y <= pos.y and pos.y < box.y + box.height)
        then
        return {
            x = (pos.x - box.x) / box.width,
            y = (pos.y - box.y) / box.height
        }
    end
end

local function HSVToRGB(HSV)
    local HDegrees = 6 * HSV.H
    
    local C = HSV.V * HSV.S
    local X = C * (1 - math.abs(HDegrees % 2 - 1))
    local m = HSV.V - C

    local RPrime = math.abs(HDegrees - 3) >= 2 and C or math.abs(HDegrees - 3) >= 1 and X or 0
    local GPrime = HDegrees >= 4 and 0 or math.abs(HDegrees - 2) >= 1 and X or C
    local BPrime = HDegrees < 2 and 0 or math.abs(HDegrees - 4) >= 1 and X or C

    return {
        R = RPrime + m,
        G = GPrime + m,
        B = BPrime + m
    }
end

return function(box, RGBOutput)
    local colourPicker = {}
    local HSToVRatio = 0.8
    local paddingPercent = 0.02

    colourPicker.HSV = {
        H = 1,
        S = 1,
        V = 1
    }
    colourPicker.HSBox = {
        x = box.x,
        y = box.y,
        width = box.width,
        height = (box.height * (1 - paddingPercent / 2)) * HSToVRatio
    }
    colourPicker.VBox = {
        x = box.x,
        y = box.y + box.height * HSToVRatio * (1 + paddingPercent),
        width = box.width,
        height = (box.height * (1 - paddingPercent / 2)) * (1 - HSToVRatio)
    }
    colourPicker.shader = SHADERS.colourPicker

    function colourPicker:update(state)
        if MOUSE.left.clicked then
            local HSCoords = getRelativeCoords(self.HSBox, MOUSE.left.pos)
            local VCoords = getRelativeCoords(self.VBox, MOUSE.left.pos)
            if HSCoords then
                self.HSV.H = HSCoords.x
                self.HSV.S = 1 - HSCoords.y
            elseif VCoords then
                self.HSV.V = VCoords.x
            end

            if HSCoords or VCoords then
                local rgb = HSVToRGB(self.HSV)
                RGBOutput.r = rgb.R
                RGBOutput.g = rgb.G
                RGBOutput.b = rgb.B
            end
        end
    end

    function colourPicker:draw()
        local img = ASSETS.textures.whiteSquare
        SHADERS.HSColourPicker:send("V", self.HSV.V)
        love.graphics.setShader(SHADERS.HSColourPicker)
        love.graphics.draw(
            img,
            self.HSBox.x,
            self.HSBox.y,
            0,
            self.HSBox.width / img:getWidth(),
            self.HSBox.height / img:getHeight()
        )
        love.graphics.setShader(SHADERS.VColourPicker)
        love.graphics.draw(
            img,
            self.VBox.x,
            self.VBox.y,
            0,
            self.VBox.width / img:getWidth(),
            self.VBox.height / img:getHeight()
        )
        love.graphics.setShader()
    end

    return colourPicker
end
