TICK_PER_SECOND = 20
TICK_PER_MINUTE = 1200
local _secondCounter = 0
local _minuteCounter = 0

TICK_PLAYER_SAVE = 20
local _playerSaveCounter = 0

function EventSubscribe()
    ScriptSupportEvent:registerEvent([=[Game.Run]=], Update)
end

function Update()
    _secondCounter = _secondCounter + 1
    _minuteCounter = _minuteCounter + 1
    _playerSaveCounter = _playerSaveCounter + 1

    -- one second
    if _secondCounter >= TICK_PER_SECOND then
        _secondCounter = 0
        OnGarbagePileRefreshTick()

        -- one minute
        if _minuteCounter >= TICK_PER_MINUTE then
            _minuteCounter = 0
        end
    end

    -- player data save
    if _playerSaveCounter >= TICK_PLAYER_SAVE then
        _playerSaveCounter = 0
        --OnPlayerDataSaveTick()
    end
end

EventSubscribe()
