local BaseComponent = require 'client.gui.components.BaseComponent'

local function getRelativeCoords(box, pos)
    if (box.x <= pos.x and pos.x < box.x + box.w) and (box.y <= pos.y and pos.y < box.y + box.h) then
        return {
            x = (pos.x - box.x) / box.w,
            y = (pos.y - box.y) / box.h
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

local extraDefaultStyles = {
    gap = '4%'
}

return function(args)
    local colourPicker = BaseComponent(args, extraDefaultStyles)
    colourPicker.HSToVRatio = args.HSToVRatio or 0.8
    colourPicker.outputTbl = args.outputTbl

    colourPicker.HSV = {
        H = 1,
        S = 1,
        V = 1
    }

    local oldBake = colourPicker.bake
    function colourPicker:bake(x, y, w, h)
        oldBake(self, x, y, w, h)
        local gap = self:getPixels(self.bakedStyles.gap, h)
        self.bakedHSBox = {
            x = self.bakedBox.x,
            y = self.bakedBox.y,
            w = self.bakedBox.w,
            h = self.bakedBox.h * self.HSToVRatio - gap / 2
        }
        self.bakedVBox = {
            x = self.bakedBox.x,
            y = self.bakedBox.y + self.bakedHSBox.h + gap,
            w = self.bakedBox.w,
            h = self.bakedBox.h - self.bakedHSBox.h - gap
        }
    end

    function colourPicker.onClick(state)
        local HSCoords = getRelativeCoords(colourPicker.bakedHSBox, MOUSE.left.pos)
        local VCoords = getRelativeCoords(colourPicker.bakedVBox, MOUSE.left.pos)
        if HSCoords then
            colourPicker.HSV.H = HSCoords.x
            colourPicker.HSV.S = 1 - HSCoords.y
        elseif VCoords then
            colourPicker.HSV.V = VCoords.x
        end

        if HSCoords or VCoords then
            local rgb = HSVToRGB(colourPicker.HSV)
            colourPicker.outputTbl.r = rgb.R
            colourPicker.outputTbl.g = rgb.G
            colourPicker.outputTbl.b = rgb.B
        end
    end

    function colourPicker:draw()
        local img = ASSETS.textures.whiteSquare
        SHADERS.HSColourPicker:send('V', self.HSV.V)
        love.graphics.setShader(SHADERS.HSColourPicker)
        love.graphics.draw(
            img,
            self.bakedHSBox.x,
            self.bakedHSBox.y,
            0,
            self.bakedHSBox.w / img:getWidth(),
            self.bakedHSBox.h / img:getHeight()
        )
        love.graphics.setShader(SHADERS.VColourPicker)
        love.graphics.draw(
            img,
            self.bakedVBox.x,
            self.bakedVBox.y,
            0,
            self.bakedVBox.w / img:getWidth(),
            self.bakedVBox.h / img:getHeight()
        )
        love.graphics.setShader()
    end

    return colourPicker
end
