local timeAnalysis = {}

local currentTimes

timeAnalysis.registerMethods = function(tbl, name, deep)
    for key, value in pairs(tbl) do
        local valueType = type(value)
        local itemPath = (name or 'Anonymous') .. '.' .. key
        if valueType == 'function' then
            tbl[key] = function(...)
                if currentTimes == nil then
                    return value(...)
                end
                if currentTimes[itemPath] == nil then
                    currentTimes[itemPath] = {calls = 1, executionTime = 0}
                else
                    currentTimes[itemPath].calls = currentTimes[itemPath].calls + 1
                end
                local startTime = os.clock()
                local res = value(...)
                currentTimes[itemPath].executionTime = currentTimes[itemPath].executionTime + os.clock() - startTime
                return res
            end
        elseif valueType == 'table' and deep then
            timeAnalysis.registerMethods(value, itemPath, deep)
        end
    end
end

timeAnalysis.startAudit = function()
    currentTimes = {}
end

local function createSections(times)
    local sections = {}
    for itemPath, item in pairs(times) do
        local section = itemPath:gmatch('[^%.]+')()
        if sections[section] == nil then
            sections[section] = {
                totalCalls = item.calls,
                totalExecutionTime = item.executionTime,
                [itemPath] = item
            }
        else
            sections[section].totalCalls = sections[section].totalCalls + item.calls
            sections[section].totalExecutionTime = sections[section].totalExecutionTime + item.executionTime
            sections[section][itemPath] = item
        end
    end
    return sections
end

timeAnalysis.finishAudit = function()
    local str = ''
    for section, timeData in pairs(createSections(currentTimes)) do
        if str ~= '' then
            str = str .. '\n\n'
        end
        str = str .. '----- ' .. section .. ' -----'
        for itemPath, item in pairs(timeData) do
            if itemPath ~= 'totalCalls' and itemPath ~= 'totalExecutionTime' then
                str =
                    str ..
                    '\n  - ' ..
                        itemPath ..
                            ' Calls: ' ..
                                tostring(item.calls) ..
                                    ' Execution Time: ' ..
                                        tostring(item.executionTime) ..
                                            's Average Execution Time: ' ..
                                                tostring(item.executionTime / item.calls) .. 's'
            end
        end
        str =
            str ..
            '\nTotal Section Calls: ' ..
                tostring(timeData.totalCalls) ..
                    ' Total Section Execution Time: ' .. tostring(timeData.totalExecutionTime) .. 's'
    end
    currentTimes = nil
    return str
end

return timeAnalysis
