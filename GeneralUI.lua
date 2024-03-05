local PLAYER_INFO_UI_ID = "7331409975215736679"
local PLAYER_MONEY_UI_TEXT_ID = "7331409975215736679_54"
local PLAYER_INVENTORY_UI_TEXT_ID = "7331409975215736679_55"

function PlayerInfoUiMoneyUpdate(playerId, money)
    Customui:setText(playerId, PLAYER_INFO_UI_ID, PLAYER_MONEY_UI_TEXT_ID, "金钱: " .. money)
end

function PlayerInfoUiInventoryUpdate(playerId, inventoryCurrent, inventorySize)
    Customui:setText(playerId, PLAYER_INFO_UI_ID, PLAYER_INVENTORY_UI_TEXT_ID,
        "携带上限: " .. inventoryCurrent .. "/" .. inventorySize)
end
