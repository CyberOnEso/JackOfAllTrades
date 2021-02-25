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
            type = "submenu",
            name = SI_JACK_OF_ALL_TRADES_MENU_TOGGLE,
            controls = {
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Meticulous Disassembly")),
                    getFunc = function() return self.savedVariables.enable.meticulousDisassembly end,
                    setFunc = function(value) self.savedVariables.enable.meticulousDisassembly = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Treasure Hunter")),
                    getFunc = function() return self.savedVariables.enable.treasureHunter end,
                    setFunc = function(value) self.savedVariables.enable.treasureHunter = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Gifted Rider")),
                    getFunc = function() return self.savedVariables.enable.giftedRider end,
                    setFunc = function(value) self.savedVariables.enable.giftedRider = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("War Mount")),
                    getFunc = function() return self.savedVariables.enable.warMount end,
                    setFunc = function(value) self.savedVariables.enable.warMount = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Reel Technique")),
                    getFunc = function() return self.savedVariables.enable.reelTechnique end,
                    setFunc = function(value) self.savedVariables.enable.reelTechnique = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Anglers Instincts")),
                    getFunc = function() return self.savedVariables.enable.anglersInstincts end,
                    setFunc = function(value) self.savedVariables.enable.anglersInstincts = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Master Gatherer")),
                    getFunc = function() return self.savedVariables.enable.masterGatherer end,
                    setFunc = function(value) self.savedVariables.enable.masterGatherer = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Plentiful Harvest")),
                    getFunc = function() return self.savedVariables.enable.plentifulHarvest end,
                    setFunc = function(value) self.savedVariables.enable.plentifulHarvest = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Professional Upkeep")),
                    getFunc = function() return self.savedVariables.enable.professionalUpkeep end,
                    setFunc = function(value) self.savedVariables.enable.professionalUpkeep = value end,
                    width = "half"
                },
            },
        },
        {
            type = "header",
            name = SI_JACK_OF_ALL_TRADES_MENU_NOTIFICATIONS,
            width = "full"
        },
        {
            type = "description",
            text = SI_JACK_OF_ALL_TRADES_MENU_NOTIFICATIONS_DESCRIPTION_GLOBAL,
            width = "full"
        },
        {   
            type = "checkbox",
            name = SI_JACK_OF_ALL_TRADES_MENU_NOTIFICATIONS_GLOBAL,
            -- If all nodes are true, set to True, else false
            getFunc = function() 
                        for node, state in pairs(self.savedVariables.notification) do 
                            if self.savedVariables.notification[node] == false then 
                                return false 
                            end 
                        end 
                        return true
                    end,
            -- Set all nodes to this value
            setFunc = function(value)
                        for node, state in pairs(self.savedVariables.notification) do 
                            self.savedVariables.notification[node] = value
                        end 
                    end,
            width = "full"
        },
        {   
            type = "submenu",
            name = SI_JACK_OF_ALL_TRADES_MENU_NOTIFICATIONS_INDIVIDUAL,
            controls = {
                {   
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Meticulous Disassembly")),
                    getFunc = function() return self.savedVariables.notification.meticulousDisassembly end,
                    setFunc = function(value) self.savedVariables.notification.meticulousDisassembly = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Treasure Hunter")),
                    getFunc = function() return self.savedVariables.notification.treasureHunter end,
                    setFunc = function(value) self.savedVariables.notification.treasureHunter = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Gifted Rider")),
                    getFunc = function() return self.savedVariables.notification.giftedRider end,
                    setFunc = function(value) self.savedVariables.notification.giftedRider = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("War Mount")),
                    getFunc = function() return self.savedVariables.notification.warMount end,
                    setFunc = function(value) self.savedVariables.notification.warMount = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Reel Technique")),
                    getFunc = function() return self.savedVariables.notification.reelTechnique end,
                    setFunc = function(value) self.savedVariables.notification.reelTechnique = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Anglers Instincts")),
                    getFunc = function() return self.savedVariables.notification.anglersInstincts end,
                    setFunc = function(value) self.savedVariables.notification.anglersInstincts = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Master Gatherer")),
                    getFunc = function() return self.savedVariables.notification.masterGatherer end,
                    setFunc = function(value) self.savedVariables.notification.masterGatherer = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Plentiful Harvest")),
                    getFunc = function() return self.savedVariables.notification.plentifulHarvest end,
                    setFunc = function(value) self.savedVariables.notification.plentifulHarvest = value end,
                    width = "half"
                },
                {
                    type = "checkbox",
                    name = GetChampionSkillName(self.GetSkillId("Professional Upkeep")),
                    getFunc = function() return self.savedVariables.notification.professionalUpkeep end,
                    setFunc = function(value) self.savedVariables.notification.professionalUpkeep = value end,
                    width = "half"
                },
            },
        },
        {
            type = "colorpicker",
            name = zo_strformat(SI_JACK_OF_ALL_TRADES_TEXT_COLOUR, GetString(SI_JACK_OF_ALL_TRADES_NOTIFICATION)), -- or string id or function returning a string
            getFunc = function()
                        return ConvertHexToRGB(self.savedVariables.colour.notifications)
                    end, -- (alpha is optional)
            setFunc = function(r,g,b) 
                        self.savedVariables.colour.notifications = ConvertRGBToHex(r, g, b)
                    end, -- (alpha is optional)
            disabled = function() 
                        for node, state in pairs(self.savedVariables.notification) do 
                            if self.savedVariables.notification[node] == true then 
                                return false 
                            end 
                        end 
                        return true
                    end
        },
        {
            type = "header",
            name = SI_JACK_OF_ALL_TRADES_WARNING,
            width = "full"
        },
    	{
    	    type = "description",
    	    text = SI_JACK_OF_ALL_TRADES_MENU_WARNING_DESCRIPTION,
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
            name = zo_strformat(SI_JACK_OF_ALL_TRADES_TEXT_COLOUR, GetString(SI_JACK_OF_ALL_TRADES_WARNING)), -- or string id or function returning a string
            getFunc = function()
                        return ConvertHexToRGB(self.savedVariables.colour.warnings)
                    end, -- (alpha is optional)
            setFunc = function(r,g,b) 
                        self.savedVariables.colour.warnings = ConvertRGBToHex(r, g, b)
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