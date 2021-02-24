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
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Reel Technique --
	-------------------------------------------------------------------------------------------------
	reelTechnique = {
		id = 88,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Angler's Instinct --
	-------------------------------------------------------------------------------------------------
	anglersInstincts = {
		id = 89,
		skillIndexToReplace = 2
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Master Gatherer --
	-------------------------------------------------------------------------------------------------
	masterGatherer = {
		id = 78,
		skillIndexToReplace = 2
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Plentiful Harvest --
	-------------------------------------------------------------------------------------------------
	plentifulHarvest = {
		id = 81,
		skillIndexToReplace = 1
	},
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

local reelTechnique = JackOfAllTrades.CreateCPData(skillData.reelTechnique)
local anglersInstincts = JackOfAllTrades.CreateCPData(skillData.anglersInstincts)

local masterGatherer = JackOfAllTrades.CreateCPData(skillData.masterGatherer)
local plentifulHarvest = JackOfAllTrades.CreateCPData(skillData.plentifulHarvest)

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
	if meticulousDisassembly:AttemptToSlot() == nil then 
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
local function StopOpeningChest()
	--[[ If the player is mounted we don't want to replace their nodes with their standard ones again otherwise their mount speed would go down.
	This function is called 3 seconds after harvesting begins, so in theory players could start gathering, cancel the action and then mount. --]]
	if IsMounted() then return end
	treasureHunter:AttemptToReturnSlot()
end

local function StartOpeningChest()
	local result = treasureHunter:AttemptToSlot()
	if result then
		zo_callLater(StopOpeningChest, 3000)
	elseif result == nil then 
		if JackOfAllTrades.savedVariables.warnings.treasureHunter then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.warnings.colour .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, JackOfAllTrades.treasureHunter.name, GetString(SI_JACK_OF_ALL_TRADES_TREASURE_HUNTER_BENEFIT))) end	
	end
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
-- Fishing --
-------------------------------------------------------------------------------------------------
local function startFishing()
	reelTechnique:AttemptToSlot()
    anglersInstincts:AttemptToSlot()
    -- This will check every 2 seconds if we are still fishing, if we are not then return the CP
    -- If you know a better way of doing this please let me know Cyber#0042 on discord.
    EM:RegisterForUpdate(name .. "FishingCheck", delay, function()
    	local interactText = select(1, GetGameCameraInteractableActionInfo())
    	if interactText ~= GetString(SI_GAMECAMERAACTIONTYPE17) then
    		reelTechnique:AttemptToReturnSlot()
    		anglersInstincts:AttemptToReturnSlot()
    		EM:UnregisterForUpdate(name .. "FishingCheck")
    	end
    end)
end

local function stopGathering()
	--[[ If the player is mounted we don't want to replace their nodes with their standard ones again otherwise their mount speed would go down.
	This function is called 3 seconds after harvesting begins, so in theory players could start gathering, cancel the action and then mount. --]]
	if IsMounted() then return end
	masterGatherer:AttemptToReturnSlot()
	plentifulHarvest:AttemptToReturnSlot()
end

local function startGathering()
	-- If we have enough points into either of them 
	if masterGatherer:AttemptToSlot() or plentifulHarvest:AttemptToSlot() then
		zo_callLater(stopGathering, 3000)
	end
end
-------------------------------------------------------------------------------------------------
-- When the player looks at something they can interact with, i.e. A crafting/ fishing node --
-------------------------------------------------------------------------------------------------
local delay = 2000 -- Delay so we don't have to check if we need to change CP 200 times a second
local fishingDelay = 35000 -- Longest time it takes for a fish to bite.

local registedDelay = true

-- Pre Hook for whenever the player presses the interact key
local function OnInteractKeyPressed() 
	local interactText, mainText, _, _, _, additionalInfo, _, _ = GetGameCameraInteractableActionInfo()
	if additionalInfo == ADDITIONAL_INTERACT_INFO_FISHING_NODE then startFishing() return end
	-- TODO: Make it work for all languages
	if interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_COLLECT) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_CUT) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_MINE) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_HARVEST) then 
		startGathering() 
	elseif interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_UNLOCK) or (mainText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_CHEST) and interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_USE)) then StartOpeningChest()
	end
end

local function onReticleInteractUpdate()
	if delay == 0 then return end
    EVENT_MANAGER:RegisterForUpdate(name .. "Delay", delay, function()
        delay = 300
        EVENT_MANAGER:UnregisterForUpdate(name .. "Delay")
    end)
    delay = 0
	local additionalInfo = select(5, GetGameCameraInteractableActionInfo())
    if additionalInfo == ADDITIONAL_INTERACT_INFO_FISHING_NODE then
    	isFishing = true
     	if not isFishingNodeSlotted then
     		reelTechnique:AttemptToSlot()
     		anglersInstincts:AttemptToSlot()
     		isFishing = false
     		if registedDelay then
	     		EVENT_MANAGER:RegisterForUpdate(name, fishingDelay, function() 
	     			if not isFishing then
	     				reelTechnique:AttemptToReturnSlot()
	     				anglersInstincts:AttemptToReturnSlot()
	     			end
	     		end)
	     	end
     	end
    elseif additionalInfo == ADDITIONAL_INTERACT_INFO_PICKPOCKET_CHANCE then
    	-- TODO: Add curpurses' art
    end
end

-------------------------------------------------------------------------------------------------
-- Register for events, we only want to do so if the API version is high enough  --
-------------------------------------------------------------------------------------------------
local function RegisterEvents()
	-- Meticulous Dissambly Events
	EM:RegisterForEvent(name, EVENT_CRAFTING_STATION_INTERACT, JackOfAllTrades.openCraftingStation)
	EM:RegisterForEvent(name, EVENT_END_CRAFTING_STATION_INTERACT, JackOfAllTrades.closeCraftingStation)
	
	-- Treasure Hunter Events
	--EM:RegisterForEvent(name,  EVENT_BEGIN_LOCKPICK, JackOfAllTrades.startLockpicking)
	--EM:RegisterForEvent(name,  EVENT_LOCKPICK_BROKE, JackOfAllTrades.stopLockpicking)
	--EM:RegisterForEvent(name,  EVENT_LOCKPICK_FAILED, JackOfAllTrades.stopLockpicking)
	--EM:RegisterForEvent(name,  EVENT_LOCKPICK_SUCCESS, JackOfAllTrades.stopLockpicking)

	-- Gifted Rider & War Mount Events
	EM:RegisterForEvent(name, EVENT_MOUNTED_STATE_CHANGED, JackOfAllTrades.mountStateChanged)

	-- Professional Upkeep Events
	EM:RegisterForEvent(name, EVENT_OPEN_STORE, JackOfAllTrades.openStore)
	EM:RegisterForEvent(name, EVENT_CLOSE_STORE, JackOfAllTrades.closeStore)

	-- Is called whenever you press 'E'
	-- For fishing, treasureHunter, gathering nodes etc.
	ZO_PreHook(FISHING_MANAGER, "StartInteraction", OnInteractKeyPressed)
end


function JackOfAllTrades.InitEvents()
	RegisterEvents()
end

-------------------------------------------------------------------------------------------------
-- Register for General Events  --
-------------------------------------------------------------------------------------------------
EM:RegisterForEvent(JackOfAllTrades.name, EVENT_ADD_ON_LOADED, JackOfAllTrades.AddonLoaded)
EM:RegisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_ACTIVATED, JackOfAllTrades.playerActivated)