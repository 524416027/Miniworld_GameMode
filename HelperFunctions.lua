ENABLE_DEBUG = true

_debugText = {}

Queue = {}

function Queue.New()
    return { firstIndex = nil, lastIndex = nil }
end

-- add queueNode to end of the queue
function Queue.Enqueue(queue, value)
    -- queue is empty
    if queue.firstIndex == nil then
        queue.firstIndex = 1
        queue.lastIndex = 1
        local index = queue.lastIndex
        queue[index] = value
    else
        queue.lastIndex = queue.lastIndex + 1
        local index = queue.lastIndex
        queue[index] = value
    end
end

-- remove and return the first element value
function Queue.Dequeue(queue)
    -- queue is empty
    if queue.firstIndex == nil or queue.lastIndex == nil then
        return nil
    elseif queue.firstIndex > queue.lastIndex then
        return nil
    else
        local value = queue[queue.firstIndex]
        queue[queue.firstIndex] = nil
        queue.firstIndex = queue.firstIndex + 1
        return value
    end
end

function DebugLog(text)
    if ENABLE_DEBUG then print(text) end

    -- 7333258477600327527_101
    local uiid2 = "7331720003196349482"
    local elementid2 = "7331720003196349482_2"
    local uiid = "7334303829690500967"
    local elementid = "7334303829690500967_60"

    table.insert(_debugText, text)

    if #_debugText >= 24 then
        table.remove(_debugText, 1)
    end

    printText = ""

    for _, v in pairs(_debugText) do
        printText = printText .. v .. "\n"
    end

    local hostUin = Player:getHostUin()
    Customui:setText(hostUin, uiid, elementid, printText)
end

function TableContains(tbl, key)
    found = false
    for _, v in pairs(tbl) do
        if v == key then
            found = true
        end
    end
    return found
end

function TableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
