local name = JackOfAllTrades.name

local EM = EVENT_MANAGER

local skillData = {
	-------------------------------------------------------------------------------------------------
	-- Constants for Meticulous Dissambly --
	-------------------------------------------------------------------------------------------------
	meticulousDisassembly = {
		id = 83,
		skillIndexToReplace = 1,
		stations = {1,2,6,7}
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Treasure Hunter --
	-------------------------------------------------------------------------------------------------
	treasureHunter = {
		id = 79,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Gifted Rider --
	-------------------------------------------------------------------------------------------------
	giftedRider = {
		id = 92,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for War Mount --
	-------------------------------------------------------------------------------------------------
	warMount = {
		id = 82,
		skillIndexToReplace = 2
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Professional Upkeep --
	-------------------------------------------------------------------------------------------------
	professionalUpkeep = {
		id = 1,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Sustaining Shadows --
	-------------------------------------------------------------------------------------------------
	sustainingShadows = {
		id = 65,
		skillIndexToReplace = 1
	}
}

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
-- Load in skill data  --
-------------------------------------------------------------------------------------------------
local meticulousDisassembly = JackOfAllTrades.CreateCPData(skillData.meticulousDisassembly)
local treasureHunter = JackOfAllTrades.CreateCPData(skillData.treasureHunter)
local giftedRider = JackOfAllTrades.CreateCPData(skillData.giftedRider)
local warMount = JackOfAllTrades.CreateCPData(skillData.warMount)
local professionalUpkeep = JackOfAllTrades.CreateCPData(skillData.professionalUpkeep)

-------------------------------------------------------------------------------------------------
-- Load in skill data  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.GetSkillId(str)
	if str == "Meticulous Disassembly" then return skillData.meticulousDisassembly.id 
	elseif str == "Treasure Hunter" then return skillData.treasureHunter.id
	elseif str == "Gifted Rider" then return skillData.giftedRider.id
	elseif str == "War Mount" then return skillData.warMount.id
	elseif str == "Professional Upkeep" then return skillData.professionalUpkeep.id
	elseif str == "Sustaining Shadows" then return skillData.sustainingShadows.id
	end
end

-------------------------------------------------------------------------------------------------
-- Meticulous Dissambly  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.openCraftingStation(eventcode, station)
	-- Check if we are a station that Meticulous Disassembly will affect
	if not has_value(station, skillData.meticulousDisassembly.stations) then return end
	if meticulousDisassembly:AttemptToSlot() == 1 then 
		if JackOfAllTrades.savedVariables.warnings.meticulousDisassembly then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.warnings.colour .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, JackOfAllTrades.meticulousDissasembly.name, GetString(SI_JACK_OF_ALL_TRADES_METICULOUS_DISASSEMBLY_BENEFIT))) end
	end
end

function JackOfAllTrades.closeCraftingStation(eventcode, station)
	-- Check if we are a station that Meticulous Disassembly will affect
	if not has_value(station, skillData.meticulousDisassembly.stations) then return end
	meticulousDisassembly:AttemptToReturnSlot()
end

-------------------------------------------------------------------------------------------------
-- Treasure Hunter  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.startLockpicking(eventcode)
	if treasureHunter:AttemptToSlot() == 1 then
		if JackOfAllTrades.savedVariables.warnings.treasureHunter then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.warnings.colour .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, JackOfAllTrades.treasureHunter.name, GetString(SI_JACK_OF_ALL_TRADES_TREASURE_HUNTER_BENEFIT))) end
	end
end

function JackOfAllTrades.stopLockpicking(eventcode)
	treasureHunter:AttemptToReturnSlot()
end

-------------------------------------------------------------------------------------------------
-- Gifted Rider & War Mount  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.mountStateChanged(eventcode, mounted)
	if mounted then
		giftedRider:AttemptToSlot()
		warMount:AttemptToSlot()
	else
		giftedRider:AttemptToReturnSlot()
		warMount:AttemptToReturnSlot()
	end
end

-------------------------------------------------------------------------------------------------
-- Professional Upkeep  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.openStore(eventcode)
	professionalUpkeep:AttemptToSlot()
end

function JackOfAllTrades.closeStore(eventcode)
	professionalUpkeep:AttemptToReturnSlot()
end

-------------------------------------------------------------------------------------------------
-- Register for events, we only want to do so if the API version is high enough  --
-------------------------------------------------------------------------------------------------
local function RegisterEvents()
	-- Meticulous Dissambly Events
	EM:RegisterForEvent(name, EVENT_CRAFTING_STATION_INTERACT, JackOfAllTrades.openCraftingStation)
	EM:RegisterForEvent(name, EVENT_END_CRAFTING_STATION_INTERACT, JackOfAllTrades.closeCraftingStation)
	
	-- Treasure Hunter Events
	EM:RegisterForEvent(name,  EVENT_BEGIN_LOCKPICK, JackOfAllTrades.startLockpicking)
	EM:RegisterForEvent(name,  EVENT_LOCKPICK_BROKE, JackOfAllTrades.stopLockpicking)
	EM:RegisterForEvent(name,  EVENT_LOCKPICK_FAILED, JackOfAllTrades.stopLockpicking)
	EM:RegisterForEvent(name,  EVENT_LOCKPICK_SUCCESS, JackOfAllTrades.stopLockpicking)

	-- Gifted Rider Events
	EM:RegisterForEvent(JackOfAllTrades.name, EVENT_MOUNTED_STATE_CHANGED, JackOfAllTrades.mountStateChanged)

	-- Professional Upkeep Events
	EM:RegisterForEvent(JackOfAllTrades.name, EVENT_OPEN_STORE, JackOfAllTrades.openStore)
	EM:RegisterForEvent(JackOfAllTrades.name, EVENT_CLOSE_STORE, JackOfAllTrades.closeStore)
end


function JackOfAllTrades.InitEvents()
	RegisterEvents()
end

-------------------------------------------------------------------------------------------------
-- Register for General Events  --
-------------------------------------------------------------------------------------------------
EM:RegisterForEvent(JackOfAllTrades.name, EVENT_ADD_ON_LOADED, JackOfAllTrades.AddonLoaded)
EM:RegisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_ACTIVATED, JackOfAllTrades.playerActivated)