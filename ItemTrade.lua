function EventSubscribe()
    ScriptSupportEvent:registerEvent([=[Player.ClickBlock]=], OnPlayerClickBlock)
end

function ItemSellTrash(playerId, rarity)
    local totalSellPrice = 0
    local soldPieceCount = 0
    -- get inventory grid id range
    local err, beginId, endId = Backpack:getBackpackBarIDRange(2)
    DebugLog("backpack range " .. beginId .. " to " .. endId)
    -- iteration through each grid
    for i = beginId, endId, 1 do
        local err, itemId, itemNum = Backpack:getGridItemID(playerId, i)
        -- current grid not empty, item is sellable trash
        if TRASH_ITEM_INFO[tostring(itemId)] ~= nil then
            -- sell all
            if rarity == 0 then
                -- add to the total price
                totalSellPrice = totalSellPrice + (TRASH_ITEM_INFO[tostring(itemId)][3] * itemNum)
                -- count total sell pieces
                soldPieceCount = soldPieceCount + itemNum
                -- remove items at current grid
                Backpack:removeGridItem(playerId, i, itemNum)
            else -- only sell target rarity
                if TRASH_ITEM_INFO[tostring(itemId)][2] == rarity then
                    -- add to the total price
                    totalSellPrice = totalSellPrice + (TRASH_ITEM_INFO[tostring(itemId)][3] * itemNum)
                    -- count total sell pieces
                    soldPieceCount = soldPieceCount + itemNum
                    -- remove items at current grid
                    Backpack:removeGridItem(playerId, i, itemNum)
                end
            end
        end
    end
    -- more than 0 item sold
    if soldPieceCount > 0 then
        -- add the total sold money to player data
        UpdatePlayerMoney(playerId, totalSellPrice)
        UpdatePlayerInventory(playerId, -soldPieceCount)
        Player:notifyGameInfo2Self(playerId, "总共出售" .. soldPieceCount .. "件物品，获得" .. totalSellPrice .. "金钱")
    end
end

function ToolBuy(playerId, toolId)
    local highestToolLevel = GetPlayerHighestToolLevel(playerId)
    local tool = TRASH_TOOL_INFO[toolId]
    -- player already owned this level or lower level of tool
    if tonumber(highestToolLevel) >= tool[4] then
        -- check if none of this item in bag
        local resultQuickSlot = Backpack:hasItemByBackpackBar(playerId, 1, tonumber(toolId))
        local resultInventory = Backpack:hasItemByBackpackBar(playerId, 2, tonumber(toolId))
        DebugLog("test1:" .. resultQuickSlot .. " 2:" .. resultInventory)
        -- already had one of this item in bag
        if resultQuickSlot == 0 or resultInventory == 0 then
            Player:notifyGameInfo2Self(playerId, "背包内已有此等级的工具，无法再次获得")
        else -- none of this item in bag
            -- give another one for free
            Player:notifyGameInfo2Self(playerId, "成功获得[" .. tool[1] .. "]")
            Player:gainItems(playerId, toolId, 1, 1)
            -- set the tool unable to drop
            Player:setItemAttAction(playerId, toolId, 1, true)
            Player:setItemAttAction(playerId, toolId, 2, true)
        end
    else
        local err = UpdatePlayerMoney(playerId, -tool[5])
        if err == 0 then
            Player:notifyGameInfo2Self(playerId, "成功花费" .. tool[5] .. "购买[" .. tool[1] .. "]")
            Player:gainItems(playerId, toolId, 1, 1)
            UpdatePlayerToolLevel(playerId, tool[4])
        else
            Player:notifyGameInfo2Self(playerId, "当前所持有的金钱不够购买[" .. tool[1] .. "]")
        end
    end
end

function InventoryUpgrade(playerId)
    UpgradePlayerInventory(playerId)
end

local function Start()
end

function OnPlayerClickBlock(param)
    local blockId = param['blockid']
    local playerId = param["eventobjid"]

    local sellRarity = SELL_TRIGGER_BLOCK[tostring(blockId)]
    local buyToolId = BUY_TRIGGER_BLOCK[tostring(blockId)]

    if sellRarity ~= nil then
        ItemSellTrash(playerId, sellRarity)
    elseif buyToolId ~= nil then
        ToolBuy(playerId, buyToolId)
    elseif blockId == UPGRADE_INVENTORY_BLOCK then
        InventoryUpgrade(playerId)
    end
end

EventSubscribe()
Start()
