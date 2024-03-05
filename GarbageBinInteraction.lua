local _garbagePileRefreshCount = 0

local _garbageSearching = {}
local _garbageSearchCooldown = 60
local _garbageSearchCooldownCount = {}

-- key:areaId, value:garbagePileIndex, phaseLevel
-- ["areaId"] = { "index", "graphicTextId", "phaseLevel" }
GarbageAreas = {}
GarbagePileItemJson = {}

local _rareItemToBeDisplay = {}
local _rareItemDisplayTick = 8
local _rareItemDisplayTickCount = 0

function EventSubscribe()
    --ScriptSupportEvent:registerEvent([=[Game.Start]=], Start)
    ScriptSupportEvent:registerEvent([=[Game.Run]=], Update)

    ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], OnPlayerJoinGame_GarbageInteraction)
    ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.LeaveGame]=], OnPlayerQuitGame_GarbageInteraction)

    ScriptSupportEvent:registerEvent([=[Player.AreaIn]=], OnPlayerEnterArea)
    ScriptSupportEvent:registerEvent([=[Player.AreaOut]=], OnPlayerExitArea)
    ScriptSupportEvent:registerEvent([=[Player.ClickBlock]=], OnPlayerClickBlock)
end

function RandomPickCategory(areaId, playerId, phaseIndex)
    local random = math.random(1, PHASE1_CATEGORY_RARITY[1][2])
    local targetCategoryItemPool
    local categoryIndex
    local targetItemId

    -- found the target category within range
    for i = 2, PHASE1_CATEGORY_RARITY[1][1], 1 do
        if random <= PHASE1_CATEGORY_RARITY[i][3] then
            targetCategoryItemPool = PHASE1_CATEGORY_RARITY[i][4]
            DebugLog("random category " .. random .. " " .. PHASE1_CATEGORY_RARITY[i][1])

            -- load garbage pile item count from cloud
            ReadGarbagePileItemCount()
            local areaIndex = GarbageAreas[areaId][1]
            categoryIndex   = PHASE1_CATEGORY_RARITY[1][1] - i -- common:0, uncommon:1, rare:2, legendary:3, mythical:4
            DebugLog("areaIndex:" .. areaIndex .. " categoryIndex:" .. categoryIndex)

            -- check item stock for categories other than common:0
            if categoryIndex == 0 then
                -- in common category
                targetItemId = RandomPickItem(targetCategoryItemPool, playerId)
                UpdatePlayerTrashCount(categoryIndex, playerId)
                break
            else
                -- check if the garbage pile has enough item
                if GarbagePileItemCount[areaIndex * 4 - (categoryIndex - 1)] > 0 then
                    local garbagePileItemChange = { 0, 0, 0, 0 } -- mythical, legendary, rare, uncommon
                    garbagePileItemChange[4 - (categoryIndex - 1)] = -1
                    UpdateGarbagePileItemCount(garbagePileItemChange, areaId)
                    UpdatePlayerTrashCount(categoryIndex, playerId)

                    -- pick item within the category
                    targetItemId = RandomPickItem(targetCategoryItemPool, playerId)
                    break
                end

                DebugLog("not enough item at " .. PHASE1_CATEGORY_RARITY[i][1])
            end
        end
    end

    return categoryIndex, targetItemId
end

function RandomPickItem(itemPool, playerId)
    local random = math.random(1, itemPool[1][2])
    local targetItemId

    for i = 2, itemPool[1][1], 1 do
        if random <= itemPool[i][3] then
            targetItemId = itemPool[i][1]
            DebugLog("random item " .. random ..
                " item: " .. targetItemId .. TRASH_ITEM_INFO[tostring(targetItemId)][1] ..
                " price" .. TRASH_ITEM_INFO[tostring(targetItemId)][2])
            -- give player the item
            Player:gainItems(playerId, targetItemId, 1, 2)
            -- set the item unable to drop
            Player:setItemAttAction(playerId, targetItemId, 1, true)
            Player:setItemAttAction(playerId, targetItemId, 2, true)
            --[[
            if TRASH_ITEM_INFO[tostring(targetItemId)][2] <= 3 then
                DebugLog("color index: " .. TRASH_ITEM_INFO[tostring(targetItemId)][2])
                local color = CATEGORY_TEXT_COLOUR[7 - TRASH_ITEM_INFO[tostring(targetItemId)][2]/]
                local string = color .. "+1 " .. TRASH_ITEM_INFO[tostring(targetItemId)][1]
                _rareItemToBeDisplay[playerId] = Queue.New()
                Queue.Enqueue(_rareItemToBeDisplay[playerId], string)
            end
            ]]--
            break
        end
    end

    return targetItemId
end

function ReadGarbagePileItemCount()
    local err, value = VarLib2:getGlobalVarByName(4, "trash_count")
    if value ~= nil and value ~= "" then
        GarbagePileItemCount = JSON:decode(value)
    else
        WriteGarbagePileItemCount()
    end
    UpdateGarbagePileText()
end

function WriteGarbagePileItemCount()
    -- store garbage pile item count global variable
    VarLib2:setGlobalVarByName(4, "trash_count", JSON:encode(GarbagePileItemCount))
    UpdateGarbagePileText()
end

function UpdateGarbagePileItemCount(itemChange, areaId)
    -- update garbage pile data from cloud
    ReadGarbagePileItemCount()

    -- get the garbage pile index by areaID
    local areaIndex = GarbageAreas[areaId][1]
    local itemIndex = areaIndex * 4 - 3
    -- modify data with change

    for i = 1, #itemChange, 1 do
        GarbagePileItemCount[itemIndex + (i - 1)] = itemChange[i] +
            GarbagePileItemCount[itemIndex + (i - 1)]
    end

    -- save data back to the cloud
    WriteGarbagePileItemCount()
end

function UpdateGarbagePileText()
    for _, garbageArea in pairs(GarbageAreas) do
        local displayText = ""
        for j = 1, #GARBAGE_PILE_ITEM_HEADER, 1 do
            local text = GARBAGE_PILE_ITEM_HEADER[j] .. tostring(GarbagePileItemCount[garbageArea[1] * 4 + (j - 4)])
            displayText = displayText .. text .. "\n"
        end
        local err = Graphics:updateGraphicsTextById(garbageArea[2], displayText)
        Graphics:snycGraphicsInfo2Client()
    end
end

function TriggerAreaGarbageInit()
    for i = 1, #GARBAGE_AREAS, 1 do
        -- create trigger area for garbage collection
        local err, areaId = Area:createAreaRect(
            { x = GARBAGE_AREAS[i][1][1], y = GARBAGE_AREAS[i][1][2], z = GARBAGE_AREAS[i][1][3] },
            { x = GARBAGE_AREAS[i][1][4], y = GARBAGE_AREAS[i][1][5], z = GARBAGE_AREAS[i][1][6] }
        )
        -- create and display graphic text for garbage pile
        local graphicText = Graphics:makeGraphicsText("trash pile " .. i, 16, 0, i)
        local err, graphicTextId = Graphics:createGraphicsTxtByPos(
            GARBAGE_AREAS[i][1][1], GARBAGE_AREAS[i][1][2], GARBAGE_AREAS[i][1][3],
            graphicText, 0, 0)
        -- add area into garbage area search array
        GarbageAreas[areaId] = { i, graphicTextId, GARBAGE_AREAS[i][2] }
    end
end

function OnGarbagePileRefreshTick()
    _garbagePileRefreshCount = _garbagePileRefreshCount + 1

    -- uncommon
    if _garbagePileRefreshCount % GARBAGE_PILE_REFRESH_RATE[4] == 0 then
        -- load data from the cloud
        ReadGarbagePileItemCount()

        local garbagePileItemMax = GARBAGE_PILE_ITEM_MAX[4]
        -- for every garbage pile
        for i = 4, #GarbagePileItemCount, 4 do
            -- less than maximum trash limit
            if GarbagePileItemCount[i] < garbagePileItemMax then
                -- increase number of uncommon trash by 1
                GarbagePileItemCount[i] = GarbagePileItemCount[i] + 1
            end
        end
        -- store back to cloud
        WriteGarbagePileItemCount()
    end

    -- rare
    if _garbagePileRefreshCount % GARBAGE_PILE_REFRESH_RATE[3] == 0 then
        -- load data from the cloud
        ReadGarbagePileItemCount()

        local garbagePileItemMax = GARBAGE_PILE_ITEM_MAX[3]
        -- for every garbage pile
        for i = 3, #GarbagePileItemCount, 4 do
            -- less than maximum trash limit
            if GarbagePileItemCount[i] < garbagePileItemMax then
                -- increase number of rare trash by 1
                GarbagePileItemCount[i] = GarbagePileItemCount[i] + 1
            end
        end
        -- store back to cloud
        WriteGarbagePileItemCount()
    end

    -- legendary
    if _garbagePileRefreshCount % GARBAGE_PILE_REFRESH_RATE[2] == 0 then
        -- load data from the cloud
        ReadGarbagePileItemCount()

        local garbagePileItemMax = GARBAGE_PILE_ITEM_MAX[2]
        -- for every garbage pile
        for i = 2, #GarbagePileItemCount, 4 do
            -- less than maximum trash limit
            if GarbagePileItemCount[i] < garbagePileItemMax then
                -- increase number of legendary trash by 1
                GarbagePileItemCount[i] = GarbagePileItemCount[i] + 1
            end
        end
        -- store back to cloud
        WriteGarbagePileItemCount()
    end

    -- mythical
    if _garbagePileRefreshCount % GARBAGE_PILE_REFRESH_RATE[1] == 0 then
        -- load data from the cloud
        ReadGarbagePileItemCount()

        local garbagePileItemMax = GARBAGE_PILE_ITEM_MAX[1]
        -- for every garbage pile
        for i = 1, #GarbagePileItemCount, 4 do
            -- less than maximum trash limit
            if GarbagePileItemCount[i] < garbagePileItemMax then
                -- increase number of mythical trash by 1
                GarbagePileItemCount[i] = GarbagePileItemCount[i] + 1
            end
        end
        -- store back to cloud
        WriteGarbagePileItemCount()

        -- reach to largest count number, back to count from 0
        _garbagePileRefreshCount = 0
    end
end

function Start()
    -- init trigger area for garbage collection
    TriggerAreaGarbageInit()
    ReadGarbagePileItemCount()
end

function Update()
    for key, value in pairs(_garbageSearching) do
        -- current player is on search cooldown
        if value then
            -- increase cooldown tick by 1
            _garbageSearchCooldownCount[key] = _garbageSearchCooldownCount[key] + 1

            -- cooldown end
            if _garbageSearchCooldownCount[key] >= _garbageSearchCooldown then
                -- reset cooldown time and update cooldown stat
                _garbageSearchCooldownCount[key] = 0
                _garbageSearching[key] = false
            end
        end
    end

    --[[
    _rareItemDisplayTickCount = _rareItemDisplayTickCount + 1
    if _rareItemDisplayTickCount >= _rareItemDisplayTick then
        for key, value in pairs(_rareItemToBeDisplay) do
            local dataString = Queue.Dequeue(_rareItemToBeDisplay[key])
            if dataString == nil then
                _rareItemToBeDisplay[key] = nil
            else
                local result, x, y, z = Player:getAimPos(key)
                local graphicsInfo = Graphics:makeflotageText(dataString, 16, 1)
                local result, graphid = Graphics:createflotageTextByPos(x, y, z, graphicsInfo)
            end
        end
        _rareItemDisplayTickCount = 0
    end
    ]]--
end

function OnPlayerEnterArea(param)
    local areaId = param['areaid']
    local playerId = param["eventobjid"]

    -- check if the area is for garbage collection
    if GarbageAreas[areaId] ~= nil then
        -- update the player now enter the garbage collect area
        DebugLog("player " ..
            playerId .. " enter area " .. GarbageAreas[areaId][1] .. ", phase " .. GarbageAreas[areaId][3])
        VarLib2:setPlayerVarByName(playerId, 4,
            "in_trash_area", areaId)
    end
end

function OnPlayerExitArea(param)
    local areaId = param['areaid']
    local playerId = param["eventobjid"]

    -- update the player now exit the garbage collect area
    DebugLog("player " .. playerId .. " exit area")
    VarLib2:setPlayerVarByName(playerId, 4, "in_trash_area", "")
end

function OnPlayerClickBlock(param)
    local blockId = param['blockid']
    local playerId = param["eventobjid"]
    local categoryIndexes = {}
    local itemNames = {}
    local categoryIndex
    local itemId
    local itemCount = 0
    DebugLog("click block: " .. tostring(blockId))

    -- check if the player is currently in trash area
    local err, areaId = VarLib2:getPlayerVarByName(playerId, 4, "in_trash_area")
    -- nil or "": not in area; "areaId": in an area
    if areaId == nil or areaId == "" then return end

    -- check if the plyaer is holding valid tool
    local err, toolId = Player:getCurToolID(playerId)
    if TRASH_TOOL_INFO[tostring(toolId)] == nil then
        Player:notifyGameInfo2Self(playerId, "需要使用一个趁手的工具才能在此搜寻")
        return
    else
        DebugLog("holding tool " .. TRASH_TOOL_INFO[tostring(toolId)][1])
    end

    -- check if the tool is valid for target garbage pile phase
    local garbagePilePhase = GarbageAreas[areaId][3]
    local toolPhase = TRASH_TOOL_INFO[tostring(toolId)][3]
    if toolPhase < garbagePilePhase then
        Player:notifyGameInfo2Self(playerId, "[" .. TRASH_TOOL_INFO[tostring(toolId)][1] .. "]并不适合在这个区域搜寻")
        return
    end

    -- check if the inventory had more grid than item number
    local toolObtainNum = TRASH_TOOL_INFO[tostring(toolId)][2]
    local err, num = Backpack:calcSpaceNumForItem(playerId, INVENTORY_CHECKER_ID) -- FIXME: change id to INVENTORY_CHECKER_ID
    if num < toolObtainNum then
        Player:notifyGameInfo2Self(playerId, "背包格子满啦，出售物品腾出空位后再来试试吧")
        return
    end

    -- check if search is on cooldown
    if _garbageSearching[playerId] then
        -- garbage searching is currently on cooldown
        local remainTime = (_garbageSearchCooldown - _garbageSearchCooldownCount[playerId]) * 0.05
        Player:notifyGameInfo2Self(playerId, "垃圾搜寻冷却中，还有" .. remainTime .. "秒")
        return
    end

    local errorCode = UpdatePlayerInventory(playerId, TRASH_TOOL_INFO[tostring(toolId)][2])
    if errorCode < 1 then -- <1: unsuccessful, >0 successful
        Player:notifyGameInfo2Self(playerId, "携带物品数量超过了限制，出售物品或升级携带上限后再来吧")
        return
    end
    -- >0:apply successful, -1:apply unsuccessful(not enough space)
    local itemCountToObtain = errorCode

    -- on searching garbage
    _garbageSearching[playerId] = true
    -- random number of trash out
    for i = 1, itemCountToObtain, 1 do
        categoryIndex, itemId = RandomPickCategory(areaId, playerId)
        table.insert(categoryIndexes, categoryIndex)
        table.insert(itemNames, TRASH_ITEM_INFO[tostring(itemId)][1])
        itemCount = itemCount + 1
    end

    ItemObtainUiDisplay(playerId, itemNames, categoryIndexes, itemCount)
end

function OnPlayerJoinGame_GarbageInteraction(param)
    local playerId = param.eventobjid
    if _garbageSearching[playerId] == nil then
        _garbageSearching[playerId] = false
        _garbageSearchCooldownCount[playerId] = 0
    end
end

function OnPlayerQuitGame_GarbageInteraction(param)
    local playerId = param.eventobjid
    _garbageSearching[playerId] = nil
    _garbageSearchCooldownCount[playerId] = nil
end

EventSubscribe()
Start()
