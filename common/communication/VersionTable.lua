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

local SUB_TABLE_DELETED = '$D'
local CLEAR_KEY = '$C'
local VERSION_KEY = '$V'
local function VersionMetaTable(class, initialVersion)
    local mt = {
        __newVersion = initialVersion or 0,
        __data = {[VERSION_KEY] = initialVersion or 0},
        __otherTypes = {},
        __subTables = {},
        __deletedSubTables = {},
        __metatable = 'VersionTable',
        __class = class
    }

    local DATA_VALUE_TYPES = {
        number = true,
        boolean = true,
        string = true,
        binary = true,
        ['nil'] = true
    }

    function mt.getLastVersion()
        return mt.__data[VERSION_KEY]
    end

    function mt.forceUpdate(deep)
        mt.__data[VERSION_KEY] = mt.__newVersion
        if deep then
            local _, subTable
            for _, subTable in pairs(mt.__subTables or {}) do
                if subTable ~= SUB_TABLE_DELETED then
                    subTable:forceUpdate(deep)
                end
            end
        end
    end

    function mt.clear()
        mt.__data = {[VERSION_KEY] = mt.__newVersion, [CLEAR_KEY] = mt.__newVersion}
        mt.__subTables = {}
    end

    function mt.__index(tbl, key)
        local metaPrefix = 'meta_'
        if tostring(key):sub(1, #metaPrefix) == metaPrefix then
            return mt[key:sub(#metaPrefix + 1)]
        end
        return mt.__subTables[key] ~= SUB_TABLE_DELETED and mt.__subTables[key] or mt.__otherTypes[key] or
            mt.__data[key]
    end

    function mt.__newindex(tbl, key, value)
        if key == VERSION_KEY then
            mt.__data[key] = value
            return
        end
        local valType = type(value)
        if valType == 'table' then
            -- Trigger update if overwriting a data value with a subTable
            if mt.__data[key] ~= nil then
                mt.__data[VERSION_KEY] = mt.__newVersion
                mt.__data[key] = nil
                mt.__deletedSubTables[key] = nil
            end
            if getmetatable(value) == mt.__metatable then
                mt.__subTables[key] = value
            else
                mt.__subTables[key] = mt.__class(value, mt.__data[VERSION_KEY])
            end
        elseif DATA_VALUE_TYPES[valType] then
            -- Trigger update if data value changed
            if mt.__data[key] ~= value then
                mt.__data[VERSION_KEY] = mt.__newVersion
            end
            if mt.__subTables[key] ~= nil then
                mt.__subTables[key] = nil
                mt.__deletedSubTables[key] = mt.__data[VERSION_KEY]
            end
            mt.__data[key] = value
        else
            mt.__otherTypes[key] = value
        end
    end

    function mt.clearCacheBefore(version)
        local key, val, _, subTable
        for key, val in pairs(mt.__deletedSubTables) do
            if version > val then
                mt.__deletedSubTables[key] = nil
            end
        end
        for _, subTable in pairs(mt.__subTables) do
            subTable:clearCacheBefore(version)
        end
    end

    function mt.serialiseUpdates(version, force, updatesBuilder)
        local hasDataUpdates = false
        local key, value
        for key, value in pairs((version <= mt.__data[VERSION_KEY] or force) and mt.__data or {}) do
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
            local lengthBefore = updatesBuilder.length
            value.meta_serialiseUpdates(version, force, updatesBuilder)
            if updatesBuilder.length == lengthBefore then
                updatesBuilder:removeLast(2)
            else
                hasSubTableUpdates = true
            end
        end
        for key in pairs(mt.__deletedSubTables) do
            updatesBuilder:add(hasSubTableUpdates and ',' or '[')
            updatesBuilder:add(tostring(key))
            updatesBuilder:add(SUB_TABLE_DELETED)
            hasSubTableUpdates = true
        end
        if hasSubTableUpdates then
            updatesBuilder:add(']')
        end
    end

    function mt.deserialiseUpdates(str, version, i)
        i = i or 1
        local oldVersion = mt.__data[VERSION_KEY]
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
                if key == VERSION_KEY then
                    version = version or value
                else
                    mt.__data[key] = value
                end
            end
            i = i + 1
            if version then
                mt.__data[VERSION_KEY] = version
            end
        end
        if mt.__data[CLEAR_KEY] ~= nil and mt.__data[CLEAR_KEY] > oldVersion then
            mt.__subTables = {}
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
                    if mt.__subTables[subTableKey] == nil or mt.__subTables[subTableKey] == SUB_TABLE_DELETED then
                        mt.__subTables[subTableKey] = mt.__class()
                    end
                    i = mt.__subTables[subTableKey].meta_deserialiseUpdates(str, version, i)
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

local function VersionTable(initialData, initialVersion)
    local versionTable = {}
    local mt = VersionMetaTable(VersionTable, initialVersion)
    setmetatable(versionTable, mt)

    if initialData ~= nil then
        for key, value in pairs(initialData) do
            versionTable[key] = value
        end
    end

    function versionTable:toTable()
        local tbl = {}
        local key, value, subTable
        for key, value in pairs(mt.__data) do
            tbl[key] = value
        end
        for key, subTable in pairs(mt.__subTables) do
            tbl[key] = subTable:toTable()
        end
        return tbl
    end

    function versionTable:clearCacheBefore(version)
        mt.clearCacheBefore(version)
    end

    function versionTable:clear()
        mt.clear()
    end

    function versionTable:setVersion(version)
        mt.__newVersion = version
        local _, subTable
        for _, subTable in self:subTablePairs() do
            subTable:setVersion(version)
        end
    end
    function versionTable:getNewVersion()
        return mt.__newVersion
    end
    function versionTable:getLastVersion()
        return mt.getLastVersion()
    end

    function versionTable:forceUpdate(deep)
        mt.forceUpdate(deep)
    end

    function versionTable:dataPairs()
        return pairs(mt.__data)
    end
    function versionTable:subTablePairs()
        return pairs(mt.__subTables)
    end

    function versionTable:serialiseUpdates(version, force)
        local updatesBuilder = StringBuilder()
        mt.serialiseUpdates(version, force, updatesBuilder)
        return updatesBuilder:build()
    end

    function versionTable:deserialiseUpdates(updatesString, version)
        if mt.deserialiseUpdates(updatesString, version) < #updatesString then
            error("Didn't process entire updatesString")
        end
    end

    return versionTable
end

return VersionTable
