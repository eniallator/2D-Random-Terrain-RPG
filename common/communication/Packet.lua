local packet = {}

packet.serialise = function(headers, payload)
    local msg = ''
    for key, val in pairs(headers) do
        if msg ~= '' then
            msg = msg .. '&'
        end
        msg = msg .. key .. '=' .. tostring(val)
    end
    return (msg == '' and msg or msg .. '&') .. 'payload=' .. payload
end

packet.deserialise = function(msg)
    local headers = {}
    for key, val in msg:gmatch('(%w+)=([^&]*)') do
        if key == 'payload' then
            break
        end
        headers[key] = val
    end
    return headers, msg:match('payload=(.+)$') or ''
end

return packet
