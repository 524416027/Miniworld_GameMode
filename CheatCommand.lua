--[[
-- reset player save
local err, playerId = VarLib2:getGlobalVarByName(4, "devTool_playerId")
DevTool_ResetPlayerToNew(playerId)

-- modify player money
local err, playerId = VarLib2:getGlobalVarByName(4, "devTool_playerId")
local err, amount = VarLib2:getGlobalVarByName(4, "devTool_money")
DevTool_ModifyPlayerMoney(playerId, amount)

-- modify player highest tool level
local err, playerId = VarLib2:getGlobalVarByName(4, "devTool_playerId")
local err, toolLevel = VarLib2:getGlobalVarByName(4, "devTool_toolLevel")
DevTool_ModifyPlayerToolLevel(playerId, toolLevel)
]]
--

--[[
local err, playerId = VarLib2:getGlobalVarByName(4, "command_line_playerId")
OnCommandLineInput(playerId)
]]
--

function OnCommandLineInput(playerId)
    local err, command = VarLib2:getPlayerVarByName(tonumber(playerId), 4, "command_line")
    DebugLog("command to playerId: " .. playerId .. ", command: " .. command)
    local commandWords = {}
    for word in string.gmatch(command, "%S+") do
        table.insert(commandWords, word)
    end

    if commandWords[1] == "重置玩家存档" then -- 重置玩家存档 114514
        DebugLog("reset player save command")
        DevTool_ResetPlayerToNew(commandWords[2])
    elseif commandWords[1] == "给予玩家金钱" then -- 给予玩家金钱 114514 100
        DebugLog("give player money command")
        DevTool_ModifyPlayerMoney(commandWords[2], commandWords[3])
    elseif commandWords[1] == "修改玩家武器等级" then -- 修改玩家武器等级 114514 7
        DebugLog("modify player tool level command")
        DevTool_ModifyPlayerToolLevel(commandWords[2], commandWords[3])
    end
end

function OnPlayerInputContent(param)
    local playerId = param.eventobjid
    local content = param.content

    if content == "reset me" then
        DevTool_ResetPlayerToNew(playerId)
    end

    if content == "give me money" then
        DevTool_ModifyPlayerMoney(playerId, 100)
    end

    if content == "print all player" then
        DevTool_PrintAllPlayer()
    end

    if content == "print me" then
        DevTool_PrintSelfPlayer(playerId)
    end
end

ScriptSupportEvent:registerEvent([=[Player.NewInputContent]=], OnPlayerInputContent)
