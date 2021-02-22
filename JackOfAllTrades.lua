-------------------------------------------------------------------------------------------------
-- 0.5 Changelog  --
-------------------------------------------------------------------------------------------------
-- When we are unable to slot CP points into a node, due to being in combat etc. We will attempt to slot the node again once combat ends.
-- Will remember which skill should be set back afer a reload ui! =D
-- Added method of finding names, discipline data automatically.
-- Improved localisation support

-------------------------------------------------------------------------------------------------
-- Todo list  --
-------------------------------------------------------------------------------------------------
-- Use ZOS CP class rather than your own???? 
-- skillIndexToReplace; automatically find out which skill to replace. Maybe add a menu option??
-- Flanking passive warning?

-------------------------------------------------------------------------------------------------
-- Load in global variables --
-------------------------------------------------------------------------------------------------
JackOfAllTrades = {
	name = "JackOfAllTrades",
	author = '@CyberOnEso',
	version = '0.5',
	requiredAPIVersion = 100034
}

JackOfAllTrades.colours = {
	greenCP = "|c557C29",
	author = "|c235AC4"
}

-------------------------------------------------------------------------------------------------
-- When player is activated --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.playerActivated(eventcode)
	if GetAPIVersion() < JackOfAllTrades.requiredAPIVersion then
		return
	end
	JackOfAllTrades.OnReloadUI()
	EVENT_MANAGER:UnregisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_ACTIVATED)
end

-------------------------------------------------------------------------------------------------
-- When addon is first loaded --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.AddonLoaded(eventcode, addonName)
	local name = JackOfAllTrades.name
	if addonName ~= name then return end

	if GetAPIVersion() < JackOfAllTrades.requiredAPIVersion then
		CHAT_SYSTEM:AddMessage(string.format("%sWarning: You are running a version of the game prior to the release of CP 2.0. This addon will not function and may cause errors until the release of CP 2.0.", JackOfAllTrades.WarningColour))
		return
	end

	JackOfAllTrades.InitSavedVariables()

	JackOfAllTrades.InitEvents()

	JackOfAllTrades.InitSkills()

	EVENT_MANAGER:UnregisterForEvent(name, EVENT_ADD_ON_LOADED)

	JackOfAllTrades.InitMenu()
end