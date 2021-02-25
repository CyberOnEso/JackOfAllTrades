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
	elseif str == "Reel Technique" then return skillData.reelTechnique.id
	elseif str == "Anglers Instincts" then return skillData.anglersInstincts.id
	elseif str == "Master Gatherer" then return skillData.masterGatherer.id
	elseif str == "Plentiful Harvest" then return skillData.plentifulHarvest.id
	end
end

-------------------------------------------------------------------------------------------------
-- Meticulous Dissambly  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.openCraftingStation(eventcode, station)
	if not JackOfAllTrades.savedVariables.enable.meticulousDisassembly then return end
	-- Check if we are a station that Meticulous Disassembly will affect
	if not has_value(station, skillData.meticulousDisassembly.stations) then return end
	local result = meticulousDisassembly:AttemptToSlot()
	if result then 
		if JackOfAllTrades.savedVariables.notification.meticulousDisassembly then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. GetChampionSkillName(meticulousDisassembly.id) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") end
	elseif JackOfAllTrades.savedVariables.warnings.meticulousDisassembly then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.warnings .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, JackOfAllTrades.meticulousDissasembly.name, GetString(SI_JACK_OF_ALL_TRADES_METICULOUS_DISASSEMBLY_BENEFIT)))
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
	if not JackOfAllTrades.savedVariables.enable.treasureHunter then return end
	local result = treasureHunter:AttemptToSlot()
	if result then
		if JackOfAllTrades.savedVariables.notification.treasureHunter then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. GetChampionSkillName(treasureHunter.id) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") end
		zo_callLater(StopOpeningChest, 3000)
	elseif result == nil then 
		if JackOfAllTrades.savedVariables.warnings.treasureHunter then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.warnings .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, JackOfAllTrades.treasureHunter.name, GetString(SI_JACK_OF_ALL_TRADES_TREASURE_HUNTER_BENEFIT))) end	
	end
end

-------------------------------------------------------------------------------------------------
-- Gifted Rider & War Mount  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.mountStateChanged(eventcode, mounted)
	if mounted then
		if JackOfAllTrades.savedVariables.enable.giftedRider then 
			if giftedRider:AttemptToSlot() then
				if JackOfAllTrades.savedVariables.notification.giftedRider then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. GetChampionSkillName(giftedRider.id) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") end
			end
		end
		if JackOfAllTrades.savedVariables.enable.warMount then 
			if warMount:AttemptToSlot() then
				if JackOfAllTrades.savedVariables.notification.warMount then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. GetChampionSkillName(warMount.id) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") end
			end
		end
	else
		giftedRider:AttemptToReturnSlot()
		warMount:AttemptToReturnSlot()
	end
end

-------------------------------------------------------------------------------------------------
-- Professional Upkeep  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.openStore(eventcode)
	if not JackOfAllTrades.savedVariables.enable.professionalUpkeep then return end
	if professionalUpkeep:AttemptToSlot() then 
		if JackOfAllTrades.savedVariables.notification.professionalUpkeep then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. GetChampionSkillName(professionalUpkeep.id) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") end
	end
end

function JackOfAllTrades.closeStore(eventcode)
	professionalUpkeep:AttemptToReturnSlot()
end

-------------------------------------------------------------------------------------------------
-- Fishing --
-------------------------------------------------------------------------------------------------
local function startFishing()
	local reelTechnique = JackOfAllTrades.savedVariables.enable.reelTechnique
	local anglersInstincts = JackOfAllTrades.savedVariables.enable.anglersInstincts
	if not reelTechnique and not anglersInstincts then return end
	if reelTechnique then 
		if reelTechnique:AttemptToSlot() then
			if JackOfAllTrades.savedVariables.notification.reelTechnique then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. GetChampionSkillName(reelTechnique.id) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") end
		end
	end
    if anglersInstincts then 
    	if anglersInstincts:AttemptToSlot() then
    		if JackOfAllTrades.savedVariables.notification.anglersInstincts then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. GetChampionSkillName(anglersInstincts.id) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") end
    	end
    end
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

-------------------------------------------------------------------------------------------------
-- Gathering --
-------------------------------------------------------------------------------------------------
local function stopGathering()
	--[[ If the player is mounted we don't want to replace their nodes with their standard ones again otherwise their mount speed would go down.
	This function is called 3 seconds after harvesting begins, so in theory players could start gathering, cancel the action and then mount. --]]
	if IsMounted() then return end
	masterGatherer:AttemptToReturnSlot()
	plentifulHarvest:AttemptToReturnSlot()
end

local function startGathering()
	local masterGatherer = JackOfAllTrades.savedVariables.enable.masterGatherer
	local plentifulHarvest = JackOfAllTrades.savedVariables.enable.plentifulHarvest

	if not masterGatherer and not plentifulHarvest then return end

	if masterGatherer then 
		if masterGatherer:AttemptToSlot() then 
			if JackOfAllTrades.savedVariables.notification.masterGatherer then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. GetChampionSkillName(masterGatherer.id) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") end
		end
	end
    if plentifulHarvest then 
    	if plentifulHarvest:AttemptToSlot() then 
			if JackOfAllTrades.savedVariables.notification.plentifulHarvest then CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. GetChampionSkillName(plentifulHarvest.id) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") end
    	end
    end
    
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

-------------------------------------------------------------------------------------------------
-- Register for events, we only want to do so if the API version is high enough  --
-------------------------------------------------------------------------------------------------
local function RegisterEvents()
	-- Meticulous Dissambly Events
	EM:RegisterForEvent(name, EVENT_CRAFTING_STATION_INTERACT, JackOfAllTrades.openCraftingStation)
	EM:RegisterForEvent(name, EVENT_END_CRAFTING_STATION_INTERACT, JackOfAllTrades.closeCraftingStation)

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