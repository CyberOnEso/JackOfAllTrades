-------------------------------------------------------------------------------------------------
-- Utility Functions --
-------------------------------------------------------------------------------------------------
local function ConvertRGBToHex(r, g, b)
    return string.format("|c%.2x%.2x%.2x", zo_floor(r * 255), zo_floor(g * 255), zo_floor(b * 255))
end

local function ConvertHexToRGB(colourString)
    local r=tonumber(string.sub(colourString, 3, 4), 16) or 255
    local g=tonumber(string.sub(colourString, 5, 6), 16) or 255
    local b=tonumber(string.sub(colourString, 7, 8), 16) or 255
    return r/255, g/255, b/255
end

-------------------------------------------------------------------------------------------------
-- Lib Addon Menu Variables --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades:InitMenu()
    local LAM = LibAddonMenu2
    -- If for whatever reason we can't find LAM then just don't initialize the menu 
    if LAM == nil then return end
    local panelName = "JackOfAllTradesSettings"
    local panelData = {
        type = "panel",
        name = "Jack of all Trades",
        displayName = string.format("%sJack of all Trades", self.colours.greenCP),
        author = string.format("%s@CyberOnEso|r", self.colours.author),
        website = "https://www.esoui.com/forums/showthread.php?p=43242",
        version = self.version,
        slashCommand = "/jackofalltrades",
        registerForRefresh = true
    }

    local panel = LAM:RegisterAddonPanel(panelName, panelData)
    local optionsData = {
        {
            type = "header",
            name = SI_JACK_OF_ALL_TRADES_WARNING,
            width = "full"
        },
    	{
    	    type = "description",
    	    text = SI_JACK_OF_ALL_TRADES_MENU_WARNING_DESCRIPTION, -- or string id or function returning a string
            width = "full"
    	},
        {
            type = "checkbox",
            name = GetChampionSkillName(self.GetSkillId("Meticulous Disassembly")),
            getFunc = function() return self.savedVariables.warnings.meticulousDisassembly end,
            setFunc = function(value) self.savedVariables.warnings.meticulousDisassembly = value end,
            width = "full"
        },
        {
            type = "checkbox",
            name = GetChampionSkillName(self.GetSkillId("Treasure Hunter")),
            getFunc = function() return self.savedVariables.warnings.treasureHunter end,
            setFunc = function(value) self.savedVariables.warnings.treasureHunter = value end,
            width = "full"
        },
        {
            type = "colorpicker",
            name = zo_strformat(SI_JACK_OF_ALL_TRADES_WARNING_TEXT_COLOUR, GetString(SI_JACK_OF_ALL_TRADES_WARNING)), -- or string id or function returning a string
            getFunc = function()
                        return ConvertHexToRGB(self.savedVariables.warnings.colour)
                    end, -- (alpha is optional)
            setFunc = function(r,g,b) 
                        self.savedVariables.warnings.colour = ConvertRGBToHex(r, g, b)
                    end, -- (alpha is optional)
            disabled = function() return not self.savedVariables.warnings.treasureHunter and not JackOfAllTrades.savedVariables.warnings.meticulousDisassembly end
        },
        {
            type = "header",
            name = SI_JACK_OF_ALL_TRADES_DEBUG,
            width = "full"
        },
        {
            type = "checkbox",
            name = zo_strformat(SI_JACK_OF_ALL_TRADES_ENABLE_MODE, GetString(SI_JACK_OF_ALL_TRADES_DEBUG)),
            getFunc = function() return self.savedVariables.debug end,
            setFunc = function(value) self.savedVariables.debug = value end,
            width = "full"
        },
    }
    
	LAM:RegisterOptionControls(panelName, optionsData)
end