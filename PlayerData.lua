local _playerIngame = {}
local _playerDatas = {}
local _playerDataSaveReq = {}

function EventSubscribe()
    ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.EnterGame]=], OnPlayerJoinGame)
    ScriptSupportEvent:registerEvent([=[Game.AnyPlayer.LeaveGame]=], OnPlayerQuitGame)
    ScriptSupportEvent:registerEvent([=[Game.End]=], OnGameEnd)
end

function DevTool_ResetPlayerToNew(playerId)
    InitPlayer(tostring(playerId))
end

function DevTool_ModifyPlayerMoney(playerId, amount)
    _playerDatas[tostring(playerId)]["money"] = _playerDatas[tostring(playerId)]["money"] + tonumber(amount)
    _playerDataSaveReq[tostring(playerId)] = true
end

function DevTool_ModifyPlayerToolLevel(playerId, value)
    _playerDatas[tostring(playerId)]["highestToolLevel"] = value
    _playerDataSaveReq[tostring(playerId)] = true
end

function DevTool_PrintAllPlayer()
    DebugLog(JSON:encode(_playerDatas))
end

function DevTool_PrintSelfPlayer(playerId)
    DebugLog(JSON:encode(_playerDatas[tostring(playerId)]))
end

function NewPlayerData()
    local newPlayerData = {}
    newPlayerData["firstLogin"] = ""
    newPlayerData["loginDate"] = ""
    newPlayerData["logoutDate"] = ""
    newPlayerData["playedTime"] = 0
    newPlayerData["joinTimes"] = 0
    newPlayerData["money"] = 0
    newPlayerData["totalMoney"] = 0
    newPlayerData["totalTrashFound"] = 0
    newPlayerData["trashFound"] = { 0, 0, 0, 0, 0 }
    newPlayerData["highestToolLevel"] = 1
    newPlayerData["inventoryCapacity"] = 15
    newPlayerData["inventoryUsed"] = 0
    newPlayerData["kitchenTicket"] = 0
    newPlayerData["carParkTicket"] = 0
    return newPlayerData
end

function UploadPlayerData(playerId)
    local jsonString = JSON:encode(_playerDatas[tostring(playerId)])
    VarLib2:setPlayerVarByName(tonumber(playerId), 4, "player_data", jsonString)
    DebugLog("upload player " .. playerId .. " data: " .. jsonString)
end

function InitPlayer(playerId)
    local newPlayerData = NewPlayerData()
    newPlayerData["firstLogin"] = os.time()
    newPlayerData["loginDate"] = os.time()
    newPlayerData["joinTimes"] = 1

    _playerDatas[tostring(playerId)] = newPlayerData
    _playerDataSaveReq[tostring(playerId)] = true
    DebugLog("player " .. playerId .. " does not exist, add new player")
end

function ReadPlayerData(playerId, jsonString)
    local currentPlayerDataTemplate = NewPlayerData()
    local playerData = JSON:decode(jsonString)
    -- use new data template as base
    for key, value in pairs(currentPlayerDataTemplate) do
        if playerData[key] ~= nil then
            currentPlayerDataTemplate[key] = playerData[key]
        end
    end
    -- modify such as data field change name or remove old fields
    ModifyPlayerData(currentPlayerDataTemplate, playerData)
    _playerDatas[tostring(playerId)] = currentPlayerDataTemplate
end

function ModifyPlayerData(currentPlayerDataTemplate, playerData)
end

function GetPlayerHighestToolLevel(playerId)
    return _playerDatas[tostring(playerId)]["highestToolLevel"]
end

function UpdatePlayerTrashCount(categoryIndex, playerId)
    _playerDatas[tostring(playerId)]["totalTrashFound"] = _playerDatas[tostring(playerId)]["totalTrashFound"] + 1
    _playerDatas[tostring(playerId)]["trashFound"][categoryIndex + 1] = _playerDatas[tostring(playerId)]["trashFound"][categoryIndex + 1] + 1
    -- data upload to cloud required
    _playerDataSaveReq[tostring(playerId)] = true
end

function UpdatePlayerToolLevel(playerId, level)
    local highestToolLevel = _playerDatas[tostring(playerId)]["highestToolLevel"]
    if highestToolLevel < level then
        _playerDatas[tostring(playerId)]["highestToolLevel"] = level
    end
    -- data upload to cloud required
    _playerDataSaveReq[tostring(playerId)] = true
end

function UpdatePlayerMoney(playerId, amount)
    local errorCode = -1 -- 0:apply successful, 1:apply unsuccessful(not enough money)

    -- add money
    if amount > 0 then
        _playerDatas[tostring(playerId)]["totalMoney"] = _playerDatas[tostring(playerId)]["totalMoney"] + amount
        _playerDatas[tostring(playerId)]["money"] = _playerDatas[tostring(playerId)]["money"] + amount
        -- data upload to cloud required
        _playerDataSaveReq[tostring(playerId)] = true
        errorCode = 0
        -- update ui for display money
        PlayerInfoUiMoneyUpdate(playerId, _playerDatas[tostring(playerId)]["money"])
    else -- reduct money
        local ownedMoney = _playerDatas[tostring(playerId)]["money"]
        -- player had not enough money
        if ownedMoney + amount < 0 then
            errorCode = 1
        else
            _playerDatas[tostring(playerId)]["money"] = _playerDatas[tostring(playerId)]["money"] + amount
            -- data upload to cloud required
            _playerDataSaveReq[tostring(playerId)] = true
            errorCode = 0
            -- update ui for display money
            PlayerInfoUiMoneyUpdate(playerId, _playerDatas[tostring(playerId)]["money"])
        end
    end

    return errorCode
end

function UpdatePlayerInventory(playerId, itemCountToObtain)
    local errorCode = -1 -- >=1:apply successful, -1:apply unsuccessful(not enough space)

    -- add item
    if itemCountToObtain > 0 then
        -- count of remaining space
        local remainSpace = _playerDatas[tostring(playerId)]["inventoryCapacity"] - _playerDatas[tostring(playerId)]["inventoryUsed"]
        -- space more than amount
        if remainSpace >= itemCountToObtain then
            errorCode = itemCountToObtain
        else
            errorCode = remainSpace
        end
        _playerDatas[tostring(playerId)]["inventoryUsed"] = _playerDatas[tostring(playerId)]["inventoryUsed"] + errorCode
        -- data upload to cloud required
        _playerDataSaveReq[playerId] = true
        -- update ui for display inventory
        PlayerInfoUiInventoryUpdate(playerId, _playerDatas[tostring(playerId)]["inventoryUsed"],
            _playerDatas[tostring(playerId)]["inventoryCapacity"])
    else -- remove item
        _playerDatas[tostring(playerId)]["inventoryUsed"] = _playerDatas[tostring(playerId)]["inventoryUsed"] + itemCountToObtain
        if _playerDatas[tostring(playerId)]["inventoryUsed"] < 0 then
            _playerDatas[tostring(playerId)]["inventoryUsed"] = 0
        end
        -- data upload to cloud required
        _playerDataSaveReq[tostring(playerId)] = true
        errorCode = 1
        -- update ui for display inventory
        PlayerInfoUiInventoryUpdate(playerId, _playerDatas[tostring(playerId)]["inventoryUsed"],
            _playerDatas[tostring(playerId)]["inventoryCapacity"])
    end

    return errorCode
end

function UpgradePlayerInventory(playerId)
    local inventoryCapacity = _playerDatas[tostring(playerId)]["inventoryCapacity"]
    local upgradeCost = 25
    local upgradeSize = 5
    local maxUpgradeSize = 250
    -- if the capacity already reach to the maximum
    if inventoryCapacity >= maxUpgradeSize then
        Player:notifyGameInfo2Self(playerId, maxUpgradeSize .. "个物品的携带上限已升级到最高级")
        return
    end
    -- capacity < 100 cost 25, capacity > 100 and < 250 cost 75
    if inventoryCapacity >= 100 then
        upgradeCost = 75
    end
    local err = UpdatePlayerMoney(playerId, -upgradeCost)
    if err == 0 then
        Player:notifyGameInfo2Self(playerId, "成功花费" .. upgradeCost .. "金钱升级携带上限到" .. inventoryCapacity + upgradeSize)
        -- apply new inventory capacity to player save
        _playerDatas[tostring(playerId)]["inventoryCapacity"] = _playerDatas[tostring(playerId)]["inventoryCapacity"] + upgradeSize
        -- data upload to cloud required
        _playerDataSaveReq[tostring(playerId)] = true
        -- update ui for display inventory
        PlayerInfoUiInventoryUpdate(playerId, _playerDatas[tostring(playerId)]["inventoryUsed"],
            _playerDatas[tostring(playerId)]["inventoryCapacity"])
    else
        Player:notifyGameInfo2Self(playerId, "当前所持有的金钱不够" .. upgradeCost .. "用于升级携带上限")
    end
end



function OnPlayerDataSaveTick()
    -- iterate all player data and check if save needed
    for key, value in pairs(_playerDatas) do
        if _playerDataSaveReq[key] == true then
            DebugLog("save required for id " .. key)
            UploadPlayerData(key)
            _playerDataSaveReq[key] = false
            -- if the player no longer in game, remove data from memory
            if _playerIngame[key] == false then
                table.remove(_playerDatas, key)
                table.remove(_playerDataSaveReq, key)
                table.remove(_playerIngame, key)
            end
        end
    end
end

function OnPlayerJoinGame(param)
    local playerId = param.eventobjid

    -- player current in game
    _playerIngame[tostring(playerId)] = true

    -- local player data exist
    if _playerDatas[tostring(playerId)] ~= nil then
        DebugLog("player local data exist")
        -- update login date
        _playerDatas[tostring(playerId)]["loginDate"] = os.time()
        _playerDatas[tostring(playerId)]["joinTimes"] = _playerDatas[tostring(playerId)]["joinTimes"] + 1
        _playerDataSaveReq[tostring(playerId)] = true
    else
        -- get player data from private variable
        local err, value = VarLib2:getPlayerVarByName(playerId, 4, "player_data")
        if value ~= nil and value ~= "" then
            DebugLog("player cloud data exist")
            -- player data exist at private variable
            ReadPlayerData(tostring(playerId), value)
            -- local tempTime = os.date("*t", _playerDatas[tostring(playerId)]["loginDate"])

            -- update login date
            _playerDatas[tostring(playerId)]["loginDate"] = os.time()
            _playerDatas[tostring(playerId)]["joinTimes"] = _playerDatas[tostring(playerId)]["joinTimes"] + 1
            _playerDataSaveReq[tostring(playerId)] = true
        else
            InitPlayer(tostring(playerId))
        end
    end
    -- update ui for display money
    PlayerInfoUiMoneyUpdate(tostring(playerId), _playerDatas[tostring(playerId)]["money"])
    -- update ui for display inventory
    PlayerInfoUiInventoryUpdate(tostring(playerId), _playerDatas[tostring(playerId)]["inventoryUsed"],
        _playerDatas[tostring(playerId)]["inventoryCapacity"])
end

function OnPlayerQuitGame(param)
    local playerId = param.eventobjid
    local isLocal = Player:isMainPlayer(playerId)
    if isLocal ~= 0 then return end

    _playerDatas[tostring(playerId)]["logoutDate"] = os.clock()

    _playerDataSaveReq[tostring(playerId)] = true
    -- player quit game, to be free memory space
    _playerIngame[tostring(playerId)] = false
end

function OnGameEnd()
end

EventSubscribe();
