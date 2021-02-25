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
		warnings = "|ce60000",
		notifications = "|c557C29"
	},
	warnings = {
		meticulousDisassembly = false,
		treasureHunter = false,
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
		plentifulHarvest = true
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
		plentifulHarvest = false
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