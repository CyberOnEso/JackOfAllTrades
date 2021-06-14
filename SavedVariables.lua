-------------------------------------------------------------------------------------------------
-- Variable Version, update if we need to overwrite the users files --
-------------------------------------------------------------------------------------------------
JackOfAllTrades.variableVersion = 2
-------------------------------------------------------------------------------------------------
-- Default Data --
-------------------------------------------------------------------------------------------------
local defaultData = {
	debug = false,
	showCooldownError = true,
	homemakerCorpses = false,
	thHmPair = false,
	slotSkillsAfterCooldownEnds = true,
	slotMdWhilstDoingWrits = true,
	slotLeTrashPots = true,
	slotThInDungeon = false,
	altertedAfterCooldownOver = false,
	alertNotification = false,
	alertWarning = false,
	textureNotification = true,
	colour = {
		warnings = "|cba6a1a",
		notifications = "|c638C29"
	},
	warnings = {
		meticulousDisassembly = false,
		treasureHunter = false,
		professionalUpkeep = false,
		reelTechnique = false,
		anglersInstinct = false,
		masterGatherer = false,
		plentifulHarvest = false,
		cutpursesArt = false,
		infamous = false,
		homemaker = false,
		rationer = false,
		liquidEfficiency = false,
		giftedRider = false,
		warMount = false
	},
	enable = {
		meticulousDisassembly = true,
		treasureHunter = true,
		professionalUpkeep = true,
		reelTechnique = true,
		anglersInstinct = true,
		masterGatherer = true,
		plentifulHarvest = true,
		cutpursesArt = true,
		infamous = true,
		homemaker = true,
		rationer = true,
		liquidEfficiency = true,
		giftedRider = false,
		warMount = false
	},
	notification = {
		meticulousDisassembly = true,
		treasureHunter = true,
		professionalUpkeep = true,
		reelTechnique = true,
		anglersInstinct = true,
		masterGatherer = true,
		plentifulHarvest = true,
		cutpursesArt = true,
		infamous = true,
		homemaker = true,
		rationer = true,
		liquidEfficiency = true,
		giftedRider = true,
		warMount = true
	},
	slotIndex = {
		meticulousDisassembly = 4,
		treasureHunter = 4,
		professionalUpkeep = 4,
		reelTechnique = 4,
		anglersInstinct = 3,
		masterGatherer = 4,
		plentifulHarvest = 3,
		cutpursesArt = 4,
		infamous = 4,
		homemaker = 3,
		rationer = 4,
		liquidEfficiency = 3,
		giftedRider = 4,
		warMount = 3
	},
}

-------------------------------------------------------------------------------------------------
-- Load in the saved variables  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.InitSavedVariables()
	-------------------------------------------------------------------------------------------------
	-- Load in the savedVariables --
	-------------------------------------------------------------------------------------------------
	JackOfAllTrades.savedVariables = ZO_SavedVars:NewAccountWide("JackOfAllTradesData", JackOfAllTrades.variableVersion, nil, defaultData)
	-------------------------------------------------------------------------------------------------
	-- If we reloadui whilst in combat, we still need to return the skill after combat ends --
	-------------------------------------------------------------------------------------------------
	if JackOfAllTrades.savedVariables.inCombatDuringReloadUI then
		EVENT_MANAGER:RegisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_COMBAT_STATE, JackOfAllTrades.whenCombatEndsSlotSkill)
	end
end

function JackOfAllTrades.ResetSavedVariables()
	JackOfAllTrades.savedVariables = defaultData
end

function JackOfAllTrades.resetSkillSlots()
	JackOfAllTrades.savedVariables.slotIndex = defaultData.slotIndex
end