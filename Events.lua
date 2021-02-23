local name = JackOfAllTrades.name
-------------------------------------------------------------------------------------------------
-- Utility to check if table has value  --
-------------------------------------------------------------------------------------------------
local function has_value (val, tab)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-------------------------------------------------------------------------------------------------
-- Meticulous Dissambly  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.openCraftingStation(eventcode, station)
	-- Check if we are a station that Meticulous Disassembly will affect
	if not has_value(station, JackOfAllTrades.meticulousDisassemblyStations) then return end
	if JackOfAllTrades.meticulousDisassembly:AttemptToSlot() == 1 then 
		if JackOfAllTrades.savedVariables.warnings.meticulousDisassembly then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.warnings.colour .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, JackOfAllTrades.meticulousDissasembly.name, GetString(SI_JACK_OF_ALL_TRADES_METICULOUS_DISASSEMBLY_BENEFIT))) end
	end
end

function JackOfAllTrades.closeCraftingStation(eventcode, station)
	-- Check if we are a station that Meticulous Disassembly will affect
	if not has_value(station, JackOfAllTrades.meticulousDisassemblyStations) then return end
	JackOfAllTrades.meticulousDisassembly:AttemptToReturnSlot()
end

-------------------------------------------------------------------------------------------------
-- Treasure Hunter  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.startLockpicking(eventcode)
	if JackOfAllTrades.treasureHunter:AttemptToSlot() == 1 then
		if JackOfAllTrades.savedVariables.warnings.treasureHunter then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.warnings.colour .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, JackOfAllTrades.treasureHunter.name, GetString(SI_JACK_OF_ALL_TRADES_TREASURE_HUNTER_BENEFIT))) end
	end
end

function JackOfAllTrades.stopLockpicking(eventcode)
	JackOfAllTrades.treasureHunter:AttemptToReturnSlot()
end

-------------------------------------------------------------------------------------------------
-- Gifted Rider & War Mount  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.mountStateChanged(eventcode, mounted)
	if mounted then
		JackOfAllTrades.giftedRider:AttemptToSlot()
		JackOfAllTrades.warMount:AttemptToSlot()
	else
		JackOfAllTrades.giftedRider:AttemptToReturnSlot()
		JackOfAllTrades.warMount:AttemptToReturnSlot()
	end
end

-------------------------------------------------------------------------------------------------
-- Professional Upkeep  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.openStore(eventcode)
	JackOfAllTrades.professionalUpkeep:AttemptToSlot()
end

function JackOfAllTrades.closeStore(eventcode)
	JackOfAllTrades.professionalUpkeep:AttemptToReturnSlot()
end

-------------------------------------------------------------------------------------------------
-- Register for events, we only want to do so if the API version is high enough  --
-------------------------------------------------------------------------------------------------
local function RegisterEvents()
	-------------------------------------------------------------------------------------------------
	-- Register for Meticulous Dissambly Events  --
	-------------------------------------------------------------------------------------------------
	EVENT_MANAGER:RegisterForEvent(name, EVENT_CRAFTING_STATION_INTERACT, JackOfAllTrades.openCraftingStation)
	EVENT_MANAGER:RegisterForEvent(name, EVENT_END_CRAFTING_STATION_INTERACT, JackOfAllTrades.closeCraftingStation)
	-------------------------------------------------------------------------------------------------
	-- Register for Treasure Hunter Events  --
	-------------------------------------------------------------------------------------------------
	EVENT_MANAGER:RegisterForEvent(name,  EVENT_BEGIN_LOCKPICK, JackOfAllTrades.startLockpicking)
	EVENT_MANAGER:RegisterForEvent(name,  EVENT_LOCKPICK_BROKE, JackOfAllTrades.stopLockpicking)
	EVENT_MANAGER:RegisterForEvent(name,  EVENT_LOCKPICK_FAILED, JackOfAllTrades.stopLockpicking)
	EVENT_MANAGER:RegisterForEvent(name,  EVENT_LOCKPICK_SUCCESS, JackOfAllTrades.stopLockpicking)
	-------------------------------------------------------------------------------------------------
	-- Register for Gifted Rider Events  --
	-------------------------------------------------------------------------------------------------
	EVENT_MANAGER:RegisterForEvent(JackOfAllTrades.name, EVENT_MOUNTED_STATE_CHANGED, JackOfAllTrades.mountStateChanged)
	-------------------------------------------------------------------------------------------------
	-- Register for Professional Upkeep Events  --
	-------------------------------------------------------------------------------------------------
	EVENT_MANAGER:RegisterForEvent(JackOfAllTrades.name, EVENT_OPEN_STORE, JackOfAllTrades.openStore)
	EVENT_MANAGER:RegisterForEvent(JackOfAllTrades.name, EVENT_CLOSE_STORE, JackOfAllTrades.closeStore)
end


function JackOfAllTrades.InitEvents()
	RegisterEvents()
end

-------------------------------------------------------------------------------------------------
-- Register for General Events  --
-------------------------------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(JackOfAllTrades.name, EVENT_ADD_ON_LOADED, JackOfAllTrades.AddonLoaded)
EVENT_MANAGER:RegisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_ACTIVATED, JackOfAllTrades.playerActivated)