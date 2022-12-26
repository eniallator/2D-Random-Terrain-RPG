local StringBuilder = require 'common.types.StringBuilder'
local Binary = require 'common.types.Binary'

local oldType = type
local type = function(val)
    local oldType = oldType(val)
    return oldType == 'table' and val.isBinary and 'binary' or oldType
end

local function serialiseValue(value)
    local valType = type(value)
    if valType == 'binary' then
        return 'b' .. value.length .. 'd' .. value.data
    elseif valType == 'string' then
        return '"' .. value:gsub('(["\\])', '\\%1') .. '"'
    end
    return tostring(value)
end

local function deserialiseValue(str, i)
    if str:sub(i, i) == '"' then
        i = i + 1
        local val = ''
        local escaped = false
        local char = str:sub(i, i)
        while i <= #str and (char ~= '"' or escaped) do
            escaped = char == '\\'
            val = val .. char
            i = i + 1
            char = str:sub(i, i)
        end
        return val:gsub('\\(["\\])', '%1'), i + 1
    elseif str:sub(i, i) == 'b' then
        i = i + 1
        local lengthStr = str:sub(i):match('^%d+')
        i = i + 1 + #lengthStr
        local endI = i + math.floor(lengthStr / 8)
        local data = str:sub(i, endI)
        return Binary(tonumber(lengthStr), data), endI + 1
    elseif str:sub(i, i + 3) == 'true' or str:sub(i, i + 4) == 'false' then
        local val = str:sub(i, i + 3) == 'true'
        return val, val and i + 4 or i + 5
    else
        -- Splitting pattern up since no optional group captures
        local wholePart = str:sub(i):match('^[+-]?%d+')
        i = i + #wholePart
        local decimalPart = str:sub(i):match('^%.%d+') or ''
        i = i + #decimalPart
        local exponentialPart = str:sub(i):match('^e[+-]?%d+') or ''
        i = i + #exponentialPart
        return tonumber(wholePart .. decimalPart .. exponentialPart), i
    end
end

local SUB_TABLE_DELETED = '$DELETED'
local AGE_KEY = '__AGE'
local function SynchronisedMetaTable(class, initialAge)
    local mt = {
        __newAge = initialAge or 0,
        __data = {[AGE_KEY] = initialAge or 0},
        __otherTypes = {},
        __subTables = {},
        __metatable = 'SynchronisedTable',
        __class = class
    }

    local DATA_VALUE_TYPES = {
        number = true,
        boolean = true,
        string = true,
        binary = true,
        ['nil'] = true
    }

    function mt.getLastAge()
        return mt.__data[AGE_KEY]
    end

    function mt.clear()
        mt.__data = {[AGE_KEY] = mt.__newAge}
        mt.__otherTypes = {}
        mt.__subTables = {}
    end

    function mt.__index(tbl, key)
        local metaPrefix = 'meta_'
        if tostring(key):sub(1, #metaPrefix) == metaPrefix then
            return mt[key:sub(#metaPrefix + 1)]
        end
        return mt.__data[key] or mt.__subTables[key] or mt.__otherTypes[key]
    end

    function mt.__newindex(tbl, key, value)
        if key == AGE_KEY then
            mt.__data[key] = value
            return
        end
        local valType = type(value)
        if valType == 'table' then
            -- Trigger update if overwriting a data value with a subTable
            if mt.__data[key] ~= nil then
                mt.__data[AGE_KEY] = mt.__newAge
                mt.__data[key] = nil
            end
            if getmetatable(value) == mt.__metatable then
                mt.__subTables[key] = value
            else
                mt.__subTables[key] = mt.__class(value, mt.__data[AGE_KEY])
            end
        elseif DATA_VALUE_TYPES[valType] then
            -- Trigger update if data value changed
            if mt.__data[key] ~= value then
                mt.__data[AGE_KEY] = mt.__newAge
            end
            mt.__subTables[key] = mt.__subTables[key] ~= nil and SUB_TABLE_DELETED or nil
            mt.__data[key] = value
        else
            mt.__otherTypes[key] = value
        end
    end

    function mt.serialiseUpdates(age, force, updatesBuilder)
        local hasDataUpdates = false
        for key, value in pairs((age <= mt.__data[AGE_KEY] or force) and mt.__data or {}) do
            if hasDataUpdates then
                updatesBuilder:add(',')
            else
                updatesBuilder:add('{')
            end
            hasDataUpdates = true
            updatesBuilder:add(key)
            updatesBuilder:add('=')
            updatesBuilder:add(serialiseValue(value))
        end
        if hasDataUpdates then
            updatesBuilder:add('}')
        end
        local hasSubTableUpdates = false
        for key, value in pairs(mt.__subTables or {}) do
            updatesBuilder:add(hasSubTableUpdates and ',' or '[')
            updatesBuilder:add(tostring(key))
            if value == SUB_TABLE_DELETED then
                mt.__subTables[key] = nil
                updatesBuilder:add(value)
                hasSubTableUpdates = true
            else
                local lengthBefore = updatesBuilder.length
                value.meta_serialiseUpdates(age, force, updatesBuilder)
                if updatesBuilder.length == lengthBefore then
                    updatesBuilder:removeLast(2)
                else
                    hasSubTableUpdates = true
                end
            end
        end
        if hasSubTableUpdates then
            updatesBuilder:add(']')
        end
    end

    function mt.deserialiseUpdates(str, age, i)
        i = i or 1
        if str:sub(i, i) == '{' then
            mt.__data = {}
            i = i + 1
            while str:sub(i, i) ~= '}' do
                local key, value = str:sub(i):match('^[^=]+')
                i = i + #key + 1
                value, i = deserialiseValue(str, i)
                if str:sub(i, i) == ',' then
                    i = i + 1
                end
                if key == AGE_KEY then
                    age = age or value
                else
                    mt.__data[key] = value
                end
            end
            i = i + 1
            if age then
                mt.__data[AGE_KEY] = age
            end
        end
        if str:sub(i, i) == '[' then
            i = i + 1
            while str:sub(i, i) ~= ']' do
                local subTableKey = str:sub(i):match('^[^$,%]{%[]+')
                i = i + #subTableKey
                if str:sub(i, i + #SUB_TABLE_DELETED - 1) == SUB_TABLE_DELETED then
                    i = i + #SUB_TABLE_DELETED
                    mt.__subTables[subTableKey] = nil
                else
                    if mt.__subTables[subTableKey] == nil then
                        mt.__subTables[subTableKey] = mt.__class()
                    end
                    i = mt.__subTables[subTableKey].meta_deserialiseUpdates(str, age, i)
                end
                local sep = str:sub(i, i)
                if sep == ',' then
                    i = i + 1
                elseif sep ~= ']' then
                    error('Malformed updates string at character ' .. i)
                end
            end
            i = i + 1
        end
        return i
    end

    return mt
end

local function SynchronisedTable(initialData, initialAge)
    local synchronisedTable = {}
    local mt = SynchronisedMetaTable(SynchronisedTable, initialAge)
    setmetatable(synchronisedTable, mt)

    if initialData ~= nil then
        for key, value in pairs(initialData) do
            synchronisedTable[key] = value
        end
    end

    function synchronisedTable:toTable()
        local tbl = {}
        for key, value in pairs(mt.__data) do
            tbl[key] = value
        end
        for key, subTable in pairs(mt.__subTables) do
            tbl[key] = subTable:toTable()
        end
        return tbl
    end

    function synchronisedTable:clear()
        mt.clear()
    end

    function synchronisedTable:setAge(age)
        mt.__newAge = age
        for _, subTable in self:subTablePairs() do
            subTable:setAge(age)
        end
    end
    function synchronisedTable:getNewAge()
        return mt.__newAge
    end
    function synchronisedTable:getLastAge()
        return mt.getLastAge()
    end

    function synchronisedTable:dataPairs()
        return pairs(mt.__data)
    end
    function synchronisedTable:subTablePairs()
        function iter(_, idx)
            local v
            repeat
                idx, v = next(mt.__subTables, idx)
            until v ~= SUB_TABLE_DELETED
            return idx, v
        end
        return iter
    end

    function synchronisedTable:serialiseUpdates(age, force)
        local updatesBuilder = StringBuilder()
        mt.serialiseUpdates(age, force, updatesBuilder)
        return updatesBuilder:build()
    end

    function synchronisedTable:deserialiseUpdates(updatesString, age)
        if mt.deserialiseUpdates(updatesString, age) < #updatesString then
            error("Didn't process entire updatesString")
        end
    end

    return synchronisedTable
end

return SynchronisedTable
