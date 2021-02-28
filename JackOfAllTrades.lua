-------------------------------------------------------------------------------------------------
-- Load in global variables --
-------------------------------------------------------------------------------------------------
JackOfAllTrades = {
	name = "JackOfAllTrades",
	author = '@CyberOnEso',
	version = '0.7',
	requiredAPIVersion = 100034
}

JackOfAllTrades.colours = {
	greenCP = "|c557C29",
	author = "|c5959D5"
}

local name = JackOfAllTrades.name
local EM = EVENT_MANAGER

-------------------------------------------------------------------------------------------------
-- When player is activated --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.playerActivated()
	if GetAPIVersion() < JackOfAllTrades.requiredAPIVersion then
		return
	end
	JackOfAllTrades.OnReloadUI()
	EVENT_MANAGER:UnregisterForEvent(name, EVENT_PLAYER_ACTIVATED)
end

-------------------------------------------------------------------------------------------------
-- When addon is first loaded --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.AddonLoaded(e, addonName)
	if addonName ~= name then return end

	if GetAPIVersion() < JackOfAllTrades.requiredAPIVersion then
		CHAT_SYSTEM:AddMessage(string.format("%sWarning: You are running a version of the game prior to the release of CP 2.0. This addon will not function and may cause errors until the release of CP 2.0.", JackOfAllTrades.WarningColour))
		return
	end
	JackOfAllTrades.Initialize()
end

-------------------------------------------------------------------------------------------------
-- Initialize --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.Initialize()
	JackOfAllTrades.InitSavedVariables()

	JackOfAllTrades.InitEvents()

	JackOfAllTrades:InitMenu()

	EVENT_MANAGER:UnregisterForEvent(name, EVENT_ADD_ON_LOADED)
end

-------------------------------------------------------------------------------------------------
-- Register for General Events  --
-------------------------------------------------------------------------------------------------
EM:RegisterForEvent(name, EVENT_ADD_ON_LOADED, JackOfAllTrades.AddonLoaded)
EM:RegisterForEvent(name, EVENT_PLAYER_ACTIVATED, JackOfAllTrades.playerActivated)