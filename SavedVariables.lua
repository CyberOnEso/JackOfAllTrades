-------------------------------------------------------------------------------------------------
-- Variable Version, update if we need to overwrite the users files --
-------------------------------------------------------------------------------------------------
JackOfAllTrades.variableVersion = 1
-------------------------------------------------------------------------------------------------
-- Default Data --
-------------------------------------------------------------------------------------------------
local defaultData = {
	debug = false,
	warnings = {
		colour = "|ce60000",
		meticulousDisassembly = false,
		treasureHunter = false,
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