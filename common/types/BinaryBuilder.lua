local Binary = require 'common.types.Binary'
local serialise = require 'common.development.serialise'

return function()
  local binaryBuilder = {}
  binaryBuilder.length = 0
  binaryBuilder.data = {0}

  function binaryBuilder:add(bit)
    self.data[#self.data] = self.data[#self.data] * 2 + bit
    self.length = self.length + 1
    if self.length % 8 == 0 then
      self.data[#self.data + 1] = 0
    end
  end

  function binaryBuilder:build()
    return Binary(self.length, string.char(unpack(self.data)))
  end

  return binaryBuilder
end
