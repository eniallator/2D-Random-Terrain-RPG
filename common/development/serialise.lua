local function serialise(tbl, offset)
    local sTab = {}
    local lastTab = true
    local spaces = ''

    if not offset then
        offset = 0
    end
    for i = 1, offset do
        spaces = spaces .. ' '
    end

    local i = 1

    for key, value in pairs(tbl) do
        local prefix = ''

        if key ~= i then
            prefix = '[' .. key .. '] = '
        end

        if type(value) == 'table' and value ~= '_G' then
            table.insert(sTab, prefix .. serialise(tbl[key], offset + 2))
            lastTab = false
        elseif type(value) == 'string' then
            table.insert(sTab, prefix .. '"' .. tbl[key] .. '"')
        else
            table.insert(sTab, prefix .. tostring(tbl[key]))
        end

        i = i + 1
    end

    local tblStr = '{'

    if not lastTab then
        tblStr = tblStr .. '\n'
    end

    for i = 1, #sTab do
        if i ~= 1 then
            tblStr = tblStr .. ','

            if not lastTab then
                tblStr = tblStr .. '\n'
            end
        end

        if not lastTab then
            tblStr = tblStr .. spaces .. '  '
        end

        tblStr = tblStr .. sTab[i]
    end

    if not lastTab then
        tblStr = tblStr .. '\n' .. spaces
    end

    return tblStr .. '}'
end

return serialise
