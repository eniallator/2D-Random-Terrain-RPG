return function(length, data)
  local binary = {}
  binary.length = length
  binary.data = data
  binary.isBinary = true

  return binary
end
