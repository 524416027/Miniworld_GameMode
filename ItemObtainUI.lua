local categorySpaces =
{
    "★★★★★|", -- mythical
    "★★★★☆|", -- legendary
    "★★★☆☆|", -- rare
    "★★☆☆☆|", -- uncommon
    "★☆☆☆☆|" -- common
}
local categoryColors =
{
    "#cbd3728", -- mythical
    "#ce39f43", -- legendary
    "#c782df4", -- rare
    "#c4698e1", -- uncommon
    "#cffffff"  -- common
}
function EventSubscribe()
    ScriptSupportEvent:registerEvent([=[Game.Run]=], Update)
end

function ItemObtainUiDisplay(playerId, itemNames, categoryIndexes, displayCount)
    -- player cursor axis
    local err, cursorX, cursorY, cursorZ = Player:getAimPos(playerId)
    -- string to be display
    local displayString = ""
    for i = 1, displayCount, 1 do
        local colorString = categoryColors[5 - categoryIndexes[i]]
        displayString =
            displayString ..
            colorString ..
            categorySpaces[5 - categoryIndexes[i]] ..
            itemNames[i] .. "\n"
    end
    local graphicsInfo = Graphics:makeflotageText(displayString, 8, tonumber(playerId))
    local err, graphicId = Graphics:createflotageTextByPos(cursorX, cursorY - 0.5, cursorZ, graphicsInfo)
end

function Update()
end

EventSubscribe()
