-------------------------------------------------------------------------------------------------
-- Variable Version, update if we need to overwrite the users files --
-------------------------------------------------------------------------------------------------
JackOfAllTrades.variableVersion = 1
-------------------------------------------------------------------------------------------------
-- Default Data --
-------------------------------------------------------------------------------------------------
local defaultData = {
	debug = false,
	colour = {
		warnings = "|cba6a1a",
		notifications = "|c638C29"
	},
	skillIndexToReplace = {
		[1] = 1,
		[2] = 2,
		[3] = 3,
		[4] = 4
	},
	warnings = {
		meticulousDisassembly = false,
		treasureHunter = false,
		giftedRider = false,
		warMount = false,
		professionalUpkeep = false,
		reelTechnique = false,
		anglersInstincts = false,
		masterGatherer = false,
		plentifulHarvest = false,
		cutpursesArt = false,
		shadowstrike = false,
		infamous = false,
		homemaker = false,
		sustainingShadows = false,
		fadeAway = false
	},
	enable = {
		meticulousDisassembly = true,
		treasureHunter = true,
		giftedRider = true,
		warMount = true,
		professionalUpkeep = true,
		reelTechnique = true,
		anglersInstincts = true,
		masterGatherer = true,
		plentifulHarvest = true,
		cutpursesArt = true,
		shadowstrike = true,
		infamous = true,
		homemaker = true,
		sustainingShadows = true,
		fadeAway = true
	},
	notification = {
		meticulousDisassembly = false,
		treasureHunter = false,
		giftedRider = false,
		warMount = false,
		professionalUpkeep = false,
		reelTechnique = false,
		anglersInstincts = false,
		masterGatherer = false,
		plentifulHarvest = false,
		cutpursesArt = false,
		shadowstrike = false,
		infamous = false,
		homemaker = false,
		sustainingShadows = false,
		fadeAway = false
	},
	category = {
		meticulousDisassembly = 1,
		treasureHunter = 1,
		giftedRider = 1,
		warMount = 2,
		professionalUpkeep = 1,
		reelTechnique = 1,
		anglersInstincts = 2,
		masterGatherer = 2,
		plentifulHarvest = 1,
		cutpursesArt = 2,
		shadowstrike = 3,
		infamous = 1,
		homemaker = 2,
		sustainingShadows = 1,
		fadeAway = 4
	},
	oldSkill = {}
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