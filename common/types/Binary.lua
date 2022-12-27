return function(length, data)
    local binary = {}

    binary.length = length
    binary.data = data

    binary.isBinary = true

    function binary:bitAt(index)
        if self.bits == nil then
            self.bits = {}
            local i, j
            for i = 1, #self.data do
                local byte = string.byte(self.data:sub(i))
                for j = 7, 0, -1 do
                    self.bits[#self.bits + 1] = math.floor(byte / (2 ^ j) % 2)
                end
            end
        end
        return self.bits[index]
    end

    function binary:toReadableString()
        local str, i = ''
        for i = 1, self.length do
            str = str .. self:bitAt(i)
        end
        return str
    end

    return binary
end
