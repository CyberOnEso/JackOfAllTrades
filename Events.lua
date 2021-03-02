local name = JackOfAllTrades.name

local EM = EVENT_MANAGER

local skillData = {
	-------------------------------------------------------------------------------------------------
	-- Constants for Meticulous Dissambly --
	-------------------------------------------------------------------------------------------------
	meticulousDisassembly = {
		rawName = 'meticulousDisassembly',
		id = 83,
		skillIndexToReplace = 1,
		isOldSkill = false,
		stations = {1,2,6,7}
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Treasure Hunter --
	-------------------------------------------------------------------------------------------------
	treasureHunter = {
		rawName = 'treasureHunter',
		id = 79,
		isOldSkill = false,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Gifted Rider --
	-------------------------------------------------------------------------------------------------
	giftedRider = {
		rawName = 'giftedRider',
		id = 92,
		isOldSkill = false,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for War Mount --
	-------------------------------------------------------------------------------------------------
	warMount = {
		rawName = 'warMount',
		id = 82,
		isOldSkill = false,
		skillIndexToReplace = 2
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Professional Upkeep --
	-------------------------------------------------------------------------------------------------
	professionalUpkeep = {
		rawName = 'professionalUpkeep',
		id = 1,
		isOldSkill = false,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Sustaining Shadows --
	-------------------------------------------------------------------------------------------------
	sustainingShadows = {
		rawName = 'sustainingShadows',
		id = 65,
		isOldSkill = false,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Reel Technique --
	-------------------------------------------------------------------------------------------------
	reelTechnique = {
		rawName = 'reelTechnique',
		id = 88,
		isOldSkill = false,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Angler's Instinct --
	-------------------------------------------------------------------------------------------------
	anglersInstincts = {
		rawName = 'anglersInstincts',
		id = 89,
		isOldSkill = false,
		skillIndexToReplace = 2
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Master Gatherer --
	-------------------------------------------------------------------------------------------------
	masterGatherer = {
		rawName = 'masterGatherer',
		id = 78,
		isOldSkill = false,
		skillIndexToReplace = 2
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Plentiful Harvest --
	-------------------------------------------------------------------------------------------------
	plentifulHarvest = {
		rawName = 'plentifulHarvest',
		id = 81,
		isOldSkill = false,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Cutpurses --
	-------------------------------------------------------------------------------------------------
	cutpursesArt = {
		rawName = 'cutpursesArt',
		id = 90,
		isOldSkill = false,
		skillIndexToReplace = 2
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Shadowstrike --
	-------------------------------------------------------------------------------------------------
	shadowstrike = {
		rawName = 'shadowstrike',
		id = 80,
		isOldSkill = false,
		skillIndexToReplace = 3
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Infamous --
	-------------------------------------------------------------------------------------------------
	infamous = {
		rawName = 'infamous',
		id = 77,
		isOldSkill = false,
		skillIndexToReplace = 1 -- You cannot repair your gear at a fence so will not conflict with Professional Upkeep
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Homemaker --
	-------------------------------------------------------------------------------------------------
	homemaker = {
		rawName = 'homemaker',
		id = 91,
		isOldSkill = false,
		skillIndexToReplace = 2 -- Secondary skill as when you loot a chest the Treasure Hunter perk will be the primary star
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Fade Away --
	-------------------------------------------------------------------------------------------------
	fadeAway = {
		rawName = 'fadeAway',
		id = 84,
		isOldSkill = false,
		skillIndexToReplace = 4 
	}
}

local CPTexture = {
	craft = "|t24:24:esoui/art/champion/champion_points_stamina_icon-hud-32.dds|t",
	warfare = "|t24:24:esoui/art/champion/champion_points_magicka_icon-hud-32|t",
	fitness = "|t24:24:esoui/art/champion/champion_points_health_icon-hud-32|t",
}

function JackOfAllTrades.GetStringOfSkillNames(skillIndexToReplace)
    local output = ""
    for _, skill in pairs(skillData) do
    	if skill.skillIndexToReplace == skillIndexToReplace then
    		output = output .. "\n" .. ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skill.id))
    	end
    end
    return output
end

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
local skill = {
	meticulousDisassembly = JackOfAllTrades.CreateCPData(skillData.meticulousDisassembly),
	treasureHunter = JackOfAllTrades.CreateCPData(skillData.treasureHunter),

	giftedRider = JackOfAllTrades.CreateCPData(skillData.giftedRider),
	warMount = JackOfAllTrades.CreateCPData(skillData.warMount),

	professionalUpkeep = JackOfAllTrades.CreateCPData(skillData.professionalUpkeep),
	infamous = JackOfAllTrades.CreateCPData(skillData.infamous),

	reelTechnique = JackOfAllTrades.CreateCPData(skillData.reelTechnique),
	anglersInstincts = JackOfAllTrades.CreateCPData(skillData.anglersInstincts),

	masterGatherer = JackOfAllTrades.CreateCPData(skillData.masterGatherer),
	plentifulHarvest = JackOfAllTrades.CreateCPData(skillData.plentifulHarvest),

	cutpursesArt = JackOfAllTrades.CreateCPData(skillData.cutpursesArt),
	shadowstrike = JackOfAllTrades.CreateCPData(skillData.shadowstrike),

	homemaker = JackOfAllTrades.CreateCPData(skillData.homemaker),

	sustainingShadows = JackOfAllTrades.CreateCPData(skillData.sustainingShadows),

	fadeAway = JackOfAllTrades.CreateCPData(skillData.fadeAway)
}

-------------------------------------------------------------------------------------------------
-- Assign skill category data, this has to be called after addon has been initzilized  --
------------------------------------------------------------------------------------------------- 
local function AssignSkillCategoryData()
	for star, key in pairs(skillData) do
		skill[star.rawName]:ChangeSkillCategory(JackOfAllTrades.savedVariables.category[star.rawName])
	end
end

-------------------------------------------------------------------------------------------------
-- Update skill category data, this will be called when the user alters the menu --
------------------------------------------------------------------------------------------------- 
function JackOfAllTrades.UpdateSkillCategory(rawName)
	skill[rawName]:ChangeSkillCategory(JackOfAllTrades.savedVariables.category[star.rawName])
end

-------------------------------------------------------------------------------------------------
-- Get id of a known skill rawName  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.GetSkillId(str) -- TODO: Use a for loop + pairs and a lookup table.
	return skillData[str].id
end

local function SendNotification(variableSkillName)
	if JackOfAllTrades.savedVariables.notification[variableSkillName] then 
		local texture = CPTexture.craft
		CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. texture .. ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id)) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") 
	end
end

local function SendWarning(variableSkillName)
	if JackOfAllTrades.savedVariables.warnings[variableSkillName] then
		local texture = CPTexture.craft 
		CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.warnings .. texture .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id)), GetString(SI_JACK_OF_ALL_TRADES_METICULOUS_DISASSEMBLY_BENEFIT)))
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
		SendNotification('meticulousDisassembly')
	elseif JackOfAllTrades.savedVariables.warnings.meticulousDisassembly then 
		SendWarning('meticulousDisassembly')
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
		SendNotification('treasureHunter')
		zo_callLater(StopOpeningChest, 3000)
	elseif result == nil then 
		if JackOfAllTrades.savedVariables.warnings.treasureHunter then 
			SendWarning('meticulousDisassembly')
		end	
	end
end

-------------------------------------------------------------------------------------------------
-- Gifted Rider & War Mount  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.mountStateChanged(eventcode, mounted)
	if mounted then
		if JackOfAllTrades.savedVariables.enable.giftedRider then 
			local giftedRiderResult = giftedRider:AttemptToSlot()
			if giftedRiderResult then
				SendNotification('giftedRider')
			elseif giftedRiderResult == nil then
				SendWarning('giftedRider')
			end
		end
		if JackOfAllTrades.savedVariables.enable.warMount then 
			local warMountResult = warMount:AttemptToSlot()
			if warMountResult then
				SendNotification('warMount')
			elseif warMountResult == nil then
				SendWarning('warMount')
			end
		end
	else
		giftedRider:AttemptToReturnSlot()
	end
end

-------------------------------------------------------------------------------------------------
-- Professional Upkeep  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.openStore(eventcode)
	if not JackOfAllTrades.savedVariables.enable.professionalUpkeep then return end
	local result = professionalUpkeep:AttemptToSlot()
	if result then 
		SendNotification('professionalUpkeep')
	elseif result == nil then
		SendWarning('professionalUpkeep')
	end
end

function JackOfAllTrades.closeStore(eventcode)
	professionalUpkeep:AttemptToReturnSlot()
end

-------------------------------------------------------------------------------------------------
-- Fishing --
-------------------------------------------------------------------------------------------------
local delay = 2000 -- Delay so we don't have to check if we need to change CP 200 times a second

local function startFishing()
	local isReelTechniqueEnabled = JackOfAllTrades.savedVariables.enable.reelTechnique
	local isAnglersInstinctsEnabled = JackOfAllTrades.savedVariables.enable.anglersInstincts
	if not reelTechnique and not anglersInstincts then return end
	if isReelTechniqueEnabled then 
		local reelTechniqueResult = reelTechnique:AttemptToSlot()
		if reelTechniqueResult then
			SendNotification('reelTechnique')
		elseif reelTechniqueResult == nil then
			SendWarning('reelTechnique')
		end
	end
    if isAnglersInstinctsEnabled then 
    	local anglersInstinctsResult = anglersInstincts:AttemptToSlot()
    	if anglersInstinctsResult then
    		SendNotification('anglersInstincts')
    	elseif anglersInstinctsResult == nil then 
    		SendWarning('anglersInstincts')
    	end
    end
    -- This will check every 2 seconds if we are still fishing, if we are not then return the CP
    -- If you know a better way of doing this please let me know Cyber#0042 on discord.

    EM:RegisterForUpdate(name .. "FishingCheck", delay, function()
    	local interactText = select(1, GetGameCameraInteractableActionInfo())
    	if interactText ~= GetString(SI_GAMECAMERAACTIONTYPE17) then
    		reelTechnique:AttemptToReturnSlot()
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
end

local function startGathering()
	local isMasterGathererEnabled = JackOfAllTrades.savedVariables.enable.masterGatherer
	local isPlentifulHarvestEnabled = JackOfAllTrades.savedVariables.enable.plentifulHarvest

	if not isMasterGathererEnabled and not isPlentifulHarvestEnabled then return end

	if isMasterGathererEnabled then 
		local masterGathererResult = masterGatherer:AttemptToSlot()
		if masterGathererResult then 
			SendNotification('masterGatherer')
		elseif masterGathererResult == nil then
			SendWarning('masterGatherer')
		end
	end
    if isPlentifulHarvestEnabled then 
    	local plentifulHarvestResult = plentifulHarvest:AttemptToSlot()
    	if plentifulHarvestResult then 
			SendNotification('plentifulHarvest')
    	elseif plentifulHarvestResult == nil then
    		SendWarning('plentifulHarvest')
    	end
    end
    
	-- If we have enough points into either of them 
	if masterGatherer:AttemptToSlot() or plentifulHarvest:AttemptToSlot() then
		zo_callLater(stopGathering, 3000)
	end
end

-------------------------------------------------------------------------------------------------
-- Pickpocket  --
-------------------------------------------------------------------------------------------------
local function StopPickpocketing()
	--[[ If the player is mounted we don't want to replace their nodes with their standard ones again otherwise their mount speed would go down.
	This function is called 3 seconds after harvesting begins, so in theory players could start gathering, cancel the action and then mount. --]]
	if IsMounted() then return end
	cutpursesArt:AttemptToReturnSlot()
end

local function StartPickpocketing()
	if not JackOfAllTrades.savedVariables.enable.cutpursesArt then return end
	local result = cutpursesArt:AttemptToSlot()
	if result then
		SendNotification('cutpursesArt')
		zo_callLater(StopPickpocketing, 3000)
	elseif result == nil then 
		if JackOfAllTrades.savedVariables.warnings.cutpursesArt then 
			SendWarning('cutpursesArt')
		end	
	end
end

-------------------------------------------------------------------------------------------------
-- Synergy Changed - Blade of Woe star  --
-------------------------------------------------------------------------------------------------
local isBladeOfWoeSlotted = false -- This is only for if the addon has slotted it
local bladeOfWoECheckCountdown = 10 -- Check if we should reslot the players old skill after 10 seconds

local function StopBladeOfWoe()
	if shadowstrike:AttemptToReturnSlot() then 
		isBladeOfWoeSlotted = false 
	end
end

local function StartBladeOfWoe()
	if not JackOfAllTrades.savedVariables.enable.shadowstrike then return end
	local result = shadowstrike:AttemptToSlot()
	if result then
		SendNotification('shadowstrike')
		isBladeOfWoeSlotted = true
	elseif result == nil then 
		if JackOfAllTrades.savedVariables.warnings.shadowstrike then 
			SendWarning('shadowstrike')
		end	
	end
end

function JackOfAllTrades.SynergyChanged(eventcode)
	local _, iconPath, _ = GetSynergyInfo()
	if iconPath == "/esoui/art/icons/achievement_darkbrotherhood_003.dds" then
		if isBladeOfWoeSlotted then return end
		StartBladeOfWoe()
		EM:RegisterForUpdate(name .. "BladeOfWoeCheck", 1000, function()
		   	bladeOfWoECheckCountdown = bladeOfWoECheckCountdown - 1
		   	if bladeOfWoECheckCountdown > 1 then 
		   		StopBladeOfWoe()
		   		EM:UnregisterForUpdate(name .. "BladeOfWoeCheck")
			end
	    end)
	end
end

-------------------------------------------------------------------------------------------------
-- Infamous  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.OpenFence(_, _, _)
	if not JackOfAllTrades.savedVariables.enable.infamous then return end
	local result = infamous:AttemptToSlot()
	if result then 
		SendNotification('infamous')
	elseif result == nil then
		SendWarning('infamous')
	end
end

-------------------------------------------------------------------------------------------------
-- Looting - Homemaker  --
-------------------------------------------------------------------------------------------------
local homemakerSlotted = false

local function StopLooting()
	--[[ If the player is mounted we don't want to replace their nodes with their standard ones again otherwise their mount speed would go down.
	This function is called 3 seconds after harvesting begins, so in theory players could start gathering, cancel the action and then mount. --]]
	if IsMounted() then
		homemakerSlotted = false
		return 
	end
	if homemaker:AttemptToReturnSlot() then
		homemakerSlotted = false
	else 
		EM:RegisterForUpdate(name .. "HomemakerCombatCheck", 5000, function()
    	if not JackOfAllTrades.homemaker:isCPSkillSlotted() then 
    		homemakerSlotted = false
    		EM:UnregisterForUpdate(name .. "HomemakerCombatCheck")
    	end
    end)

	end
end


local function StartLooting()
	if not JackOfAllTrades.savedVariables.enable.homemaker then return end
	local result = homemaker:AttemptToSlot()
	if result then
		SendNotification('homemaker')
		if not homemakerSlotted then
			homemakerSlotted = true
			zo_callLater(StopLooting, 1000)
		end
	elseif result == nil then 
		if JackOfAllTrades.savedVariables.warnings.homemaker then 
			SendWarning('homemaker')
		end	
	end
end

-------------------------------------------------------------------------------------------------
-- Stealth State Changed  --
-------------------------------------------------------------------------------------------------
local isSustainingShadowsSlotted = false

function JackOfAllTrades.stealthStateChanged(eventcode, unitTag, stealth)
	if unitTag ~= 'player' then return end
		if JackOfAllTrades.savedVariables.enable.giftedRider then 
			if stealth ~= 0 then
				local sustainingShadowsResult = sustainingShadows:AttemptToSlot()
				if sustainingShadowsResult then
					isSustainingShadowsSlotted = true
					SendNotification('sustainingShadows')
				elseif sustainingShadowsResult == nil then
					SendWarning('sustainingShadows')
				end
			elseif isSustainingShadowsSlotted then
				if sustainingShadows:AttemptToReturnSlot() then
					isSustainingShadowsSlotted = false
				end
			end
		end
end

-------------------------------------------------------------------------------------------------
-- Thieving - Fade Away  --
-------------------------------------------------------------------------------------------------
local fadeAwaySlotted = false

local function StopFadeAway()
	if not fadeAwaySlotted then return end
	--[[ If the player is mounted we don't want to replace their nodes with their standard ones again otherwise their mount speed would go down.
	This function is called 3 seconds after harvesting begins, so in theory players could start gathering, cancel the action and then mount. --]]
	if IsMounted() then
		fadeAwaySlotted = false
		return 
	end
	if fadeAway:AttemptToReturnSlot() then
		fadeAwaySlotted = false
	else 
		EM:RegisterForUpdate(name .. "FadeAwayCombatCheck", 5000, function()
    	if not JackOfAllTrades.fadeAway:isCPSkillSlotted() then 
    		fadeAwaySlotted = false
    		EM:UnregisterForUpdate(name .. "FadeAwayCombatCheck")
    	end
    end)

	end
end


local function StartFadeAway()
	if not JackOfAllTrades.savedVariables.enable.fadeAway then return end
	local result = fadeAway:AttemptToSlot()
	if result then
		SendNotification('fadeAway')
		if not fadeAwaySlotted then
			fadeAwaySlotted = true
		end
	elseif result == nil then 
		if JackOfAllTrades.savedVariables.warnings.fadeAway then 
			SendWarning('fadeAway')
		end	
	end
end

function JackOfAllTrades.BeingArrested(e, quitGame)
	StartFadeAway()
end

function JackOfAllTrades.InfamyUpdated(e, old, new, oldThreshold, newThreshold)
	if new < old then
		StopFadeAway()
	end
end

-------------------------------------------------------------------------------------------------
-- When the player looks at something they can interact with, i.e. A crafting/ fishing node --
-------------------------------------------------------------------------------------------------
-- Pre Hook for whenever the player presses the interact key
local function OnInteractKeyPressed() 
	local interactText, mainText, looted, _, additionalInfo, _, _, _ = GetGameCameraInteractableActionInfo()
	-- FISHING
	if additionalInfo == ADDITIONAL_INTERACT_INFO_FISHING_NODE then startFishing() return end
	-- LOOTING
	if (interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_SEARCH) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_STEALFROM)) and mainText ~= "Bookshelf" and not looted then
		StartLooting()
	end
	-- GATHERING
	if interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_COLLECT) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_CUT) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_MINE) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_HARVEST) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_LOOT) then 
		startGathering() 
	-- TREASURE HUNTER
	elseif interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_UNLOCK) or (mainText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_CHEST) and interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_USE)) then 
		StartOpeningChest()
	-- PICKPOCKETTING
	elseif interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_PICKPOCKET) then 
		StartPickpocketing()
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

	-- Blade of WoE events
	EM:RegisterForEvent(name, EVENT_SYNERGY_ABILITY_CHANGED, JackOfAllTrades.SynergyChanged)

	-- Infamous Events
	EM:RegisterForEvent(name, EVENT_OPEN_FENCE, JackOfAllTrades.OpenFence)

	-- Sustaining Shadows Events
	EM:RegisterForEvent(name, EVENT_STEALTH_STATE_CHANGED, JackOfAllTrades.stealthStateChanged)

	EM:RegisterForEvent(name, EVENT_JUSTICE_BEING_ARRESTED, JackOfAllTrades.BeingArrested)
	EM:RegisterForEvent(name,  EVENT_JUSTICE_INFAMY_UPDATED, JackOfAllTrades.InfamyUpdated)
end


function JackOfAllTrades.InitEvents()
	RegisterEvents()
	AssignSkillCategoryData()
end

-------------------------------------------------------------------------------------------------
-- Register for General Events  --
-------------------------------------------------------------------------------------------------
EM:RegisterForEvent(JackOfAllTrades.name, EVENT_ADD_ON_LOADED, JackOfAllTrades.AddonLoaded)
EM:RegisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_ACTIVATED, JackOfAllTrades.playerActivated)