local EM = EVENT_MANAGER
local name = JackOfAllTrades.name

local skillData = {
	professionalUpkeep = {
		id = 1,
		index = 4
	},
	meticulousDisassembly = {
		id = 83,
		index = 4
	},
	masterGatherer = {
		id = 78,
		index = 4
	},
	plentifulHarvest = {
		id = 81,
		index = 3
	},
	treasureHunter = {
		id = 79,
		index = 4
	},
	homemaker = {
		id = 91,
		index = 3
	},
	reelTechnique = {
		id = 88,
		index = 4
	},
	anglersInstinct = {
		id = 89,
		index = 3
	},
	cutpursesArt = {
		id = 90,
		index = 4
	},
	infamous = {
		id = 77,
		index = 4
	},
	rationer = {
		id = 85,
		index = 4
	},
	liquidEfficiency = {
		id = 86,
		index = 3
	},
	giftedRider = {
		id = 92,
		index = 4
	},
	warMount = {
		id = 82,
		index = 3
	}
}

local professionalUpkeep = skillData.professionalUpkeep
local meticulousDisassembly = skillData.meticulousDisassembly
local masterGatherer = skillData.masterGatherer
local plentifulHarvest = skillData.plentifulHarvest
local treasureHunter = skillData.treasureHunter
local homemaker = skillData.homemaker
local reelTechnique = skillData.reelTechnique
local anglersInstinct = skillData.anglersInstinct
local cutpursesArt = skillData.cutpursesArt
local infamous = skillData.infamous
local rationer = skillData.rationer
local liquidEfficiency = skillData.liquidEfficiency
local giftedRider = skillData.giftedRider
local warMount = skillData.warMount

local CPTexture = {
	craft = "|t24:24:esoui/art/champion/champion_points_stamina_icon-hud-32.dds|t",
	warfare = "|t24:24:esoui/art/champion/champion_points_magicka_icon-hud-32|t",
	fitness = "|t24:24:esoui/art/champion/champion_points_health_icon-hud-32|t",
}

function JackOfAllTrades.GetSkillId(rawSkillName)
	if skillData[rawSkillName] then 
		return skillData[rawSkillName].id
	end
end

local function SendWarning(variableSkillName)
	if JackOfAllTrades.savedVariables.warnings[variableSkillName] then
		local texture = CPTexture.craft 
		if JackOfAllTrades.savedVariables.alertWarning then zo_alert(ERROR, nil ,JackOfAllTrades.savedVariables.colour.warnings .. texture .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id))))
		else CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.warnings .. texture .. zo_strformat(SI_JACK_OF_ALL_TRADES_NOT_ENOUGH_POINTS_WARNING, ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id)))) end
	end
end

local skillNotificationMessageQueue = {
	professionalUpkeep = false,
	meticulousDisassembly = false,
	masterGatherer = false,
	plentifulHarvest = false,
 	treasureHunter = false,
	homemaker = false,
 	reelTechnique = false,
 	anglersInstinct = false,
 	cutpursesArt = false,
 	infamous = false,
 	rationer = false,
 	liquidEfficiency = false,
 	giftedRider = false,
 	warMount = false
}

local cooldownOverMsgQueued = false

function JackOfAllTrades.sendCooldownOverMessage()
	local texture = CPTexture.craft
	CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. texture .. GetString(SI_JACK_OF_ALL_TRADES_COOLDOWN_OVER) .. ".") 
end

local function SendNotification(variableSkillName)
	local alertNotification = JackOfAllTrades.savedVariables.alertNotification
	if JackOfAllTrades.savedVariables.notification[variableSkillName] then 
		local texture = ''
		if JackOfAllTrades.savedVariables.textureNotification then texture = CPTexture.craft end
		if JackOfAllTrades.GetCurrentCooldown() == 30 or JackOfAllTrades.GetCurrentCooldown() == 0 then
			if alertNotification then ZO_Alert(ERROR, nil, (JackOfAllTrades.savedVariables.colour.notifications .. texture .. ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id)) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".")) return end
			CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. texture .. ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id)) .. " " .. GetString(SI_JACK_OF_ALL_TRADES_SLOTTED) .. ".") 
			return
		else
			if JackOfAllTrades.savedVariables.slotSkillsAfterCooldownEnds then
				if alertNotification then 
					ZO_Alert(ERROR, nil, JackOfAllTrades.savedVariables.colour.notifications .. texture .. ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id)) .. " " .. zo_strformat(SI_JACK_OF_ALL_TRADES_DELAYED_SLOTTED, JackOfAllTrades.GetCurrentCooldown()) .. ".") 
				else
					CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. texture .. ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id)) .. " " .. zo_strformat(SI_JACK_OF_ALL_TRADES_DELAYED_SLOTTED, JackOfAllTrades.GetCurrentCooldown()) .. ".") 
				end
				if skillNotificationMessageQueue[variableSkillName] then return end
				skillNotificationMessageQueue[variableSkillName] = true
				return
			else
				if alertNotification then ZO_Alert(ERROR, nil, JackOfAllTrades.savedVariables.colour.notifications .. texture .. ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id)) .. " " .. zo_strformat(SI_JACK_OF_ALL_TRADES_COOLDOWN_DISABLED, JackOfAllTrades.GetCurrentCooldown()) .. ".")
				else CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. texture .. ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillData[variableSkillName].id)) .. " " .. zo_strformat(SI_JACK_OF_ALL_TRADES_COOLDOWN_DISABLED, JackOfAllTrades.GetCurrentCooldown()) .. ".")  end
				if JackOfAllTrades.savedVariables.altertedAfterCooldownOver and not cooldownOverMsgQueued then 
					cooldownOverMsgQueued = true
					zo_callLater(function() 
						cooldownOverMsgQueued = false 
						CHAT_SYSTEM:AddMessage(JackOfAllTrades.savedVariables.colour.notifications .. texture .. GetString(SI_JACK_OF_ALL_TRADES_COOLDOWN_OVER) .. ".")  end, JackOfAllTrades.GetCurrentCooldown()*1000) 
				end 
				JackOfAllTrades.resetSkillQueue() -- If we don't want to slot the skill after the cooldown ends then we don't want anything in the skill queue.
				return
			end
		end
	end
end

local function resetSkillNotificationMessageQueue()
	skillNotificationMessageQueue = {
		professionalUpkeep = false,
		meticulousDisassembly = false,
		masterGatherer = false,
		plentifulHarvest = false,
	 	treasureHunter = false,
		homemaker = false,
	 	reelTechnique = false,
	 	anglersInstinct = false,
	 	cutpursesArt = false,
	 	infamous = false,
	 	rationer = false,
	 	liquidEfficiency = false,
	 	giftedRider = false,
 		warMount = false
	}
end	

function JackOfAllTrades.SendQueuedNotifcations()
	for skill, value in pairs(skillNotificationMessageQueue) do
		if value then
			SendNotification(skill)
		end
	end
	resetSkillNotificationMessageQueue()
end

local function GetDesiredSlot(skillId, pairedSkillId, desiredSlot)
	if GetSlotBoundId(desiredSlot, HOTBAR_CATEGORY_CHAMPION) == pairedSkillId then
		if desiredSlot == 3 then 
			if JackOfAllTrades.savedVariables.debug then d("Paired skill already slotted in slot " .. desiredSlot) end
			return 4 
		elseif desiredSlot == 4 then 
			if JackOfAllTrades.savedVariables.debug then d("Paired skill already slotted in slot " .. desiredSlot) end
			return 3 
		else 
			if JackOfAllTrades.savedVariables.debug then d("GetDesiredSlot got a slot that is not 3 or 4") end
			return false 
		end
	end
	return desiredSlot
end

local function OpenStore(e)
	if not CanStoreRepair() then return false end
	if GetRepairAllCost() == 0 then return false end
	if not JackOfAllTrades.savedVariables.enable.professionalUpkeep then return false end
	local result = JackOfAllTrades.AddCPNodeToQueue(professionalUpkeep.id, professionalUpkeep.index)
	if result then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then
			SendNotification("professionalUpkeep")
		end
	elseif result == nil then
		SendWarning("professionalUpkeep")
	end
end

local function StartGathering()
	if not JackOfAllTrades.savedVariables.enable.masterGatherer and not JackOfAllTrades.savedVariables.enable.plentifulHarvest then return end

	local masterGathererResult = false
	local plentifulHarvestResult = false

	if JackOfAllTrades.savedVariables.enable.masterGatherer then 
		masterGathererResult = JackOfAllTrades.AddCPNodeToQueue(masterGatherer.id, GetDesiredSlot(masterGatherer.id, plentifulHarvest.id, masterGatherer.index))
	end

	if JackOfAllTrades.savedVariables.enable.plentifulHarvest then 
		plentifulHarvestResult = JackOfAllTrades.AddCPNodeToQueue(plentifulHarvest.id, GetDesiredSlot(plentifulHarvest.id, masterGatherer.id, plentifulHarvest.index))
	end

	if masterGathererResult or plentifulHarvestResult then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then
			if masterGathererResult then SendNotification("masterGatherer") end
			if plentifulHarvestResult then SendNotification("plentifulHarvest") end
		end
	end

	if masterGathererResult == nil then SendWarning("masterGatherer") end
	if plentifulHarvestResult == nil then SendWarning("plentifulHarvest") end
end

local function SlotThHmPair()
	if not JackOfAllTrades.savedVariables.enable.treasureHunter and not JackOfAllTrades.savedVariables.enable.homemaker then return end
	local treasureHunterResult = false
	local homemakerResult = false
	if JackOfAllTrades.savedVariables.enable.treasureHunter then 
		treasureHunterResult = JackOfAllTrades.AddCPNodeToQueue(treasureHunter.id, GetDesiredSlot(treasureHunter.id, homemaker.id, treasureHunter.index))
	end
	if JackOfAllTrades.savedVariables.enable.homemaker then 
		homemakerResult = JackOfAllTrades.AddCPNodeToQueue(homemaker.id, GetDesiredSlot(homemaker.id, treasureHunter.id, homemaker.index))
	end
	if treasureHunterResult or homemakerResult then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then
			if treasureHunterResult then SendNotification("treasureHunter") end
			if homemakerResult then SendNotification("homemaker") end
		end
	end
	if treasureHunterResult == nil then SendWarning("treasureHunter") end
	if homemakerResult == nil then SendWarning("homemaker") end
end

local function StartLooting()
	if JackOfAllTrades.savedVariables.thHmPair then SlotThHmPair() return false end
	if not JackOfAllTrades.savedVariables.enable.homemaker then return false end
	local result = JackOfAllTrades.AddCPNodeToQueue(homemaker.id, homemaker.index)
	if result then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then
			SendNotification("homemaker")
		end
	elseif result == nil then
		SendWarning("homemaker")
	end
end

local function StartOpeningChest()
	if JackOfAllTrades.savedVariables.thHmPair then SlotThHmPair() return false end
	if not JackOfAllTrades.savedVariables.enable.treasureHunter then return false end
	local result = JackOfAllTrades.AddCPNodeToQueue(treasureHunter.id, treasureHunter.index)
	if result then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then
			SendNotification("treasureHunter")
		end
	elseif result == nil then
		SendWarning("treasureHunter")
	end
end

local function StartPickpocketing()
	if not JackOfAllTrades.savedVariables.enable.cutpursesArt then return false end
	local result = JackOfAllTrades.AddCPNodeToQueue(cutpursesArt.id, cutpursesArt.index)
	if result then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then
			SendNotification("cutpursesArt")
		end
	elseif result == nil then
		SendWarning("cutpursesArt")
	end
end

local function OpenFence()
	if not JackOfAllTrades.savedVariables.enable.infamous then return false end
	local result = JackOfAllTrades.AddCPNodeToQueue(infamous.id, infamous.index)
	if result then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then
			SendNotification("infamous")
		end
	elseif result == nil then
		SendWarning("infamous")
	end
end

local function DoesPlayerHaveAWritQuest()
	for quest=1, GetNumJournalQuests() do
		if GetJournalQuestType(quest) == QUEST_TYPE_CRAFTING then return true end
	end
	return false
end

local function OpenCraftingStation(e, table)
	-- Check the crafting table supports MD
	if table ~= 1 and table ~= 2 and table ~= 6 and table ~= 7 then return end

	if not JackOfAllTrades.savedVariables.enable.meticulousDisassembly then return false end

	if not JackOfAllTrades.savedVariables.slotMdWhilstDoingWrits then 
		if DoesPlayerHaveAWritQuest() then
			return false 
		end
	end

	local result = JackOfAllTrades.AddCPNodeToQueue(meticulousDisassembly.id, meticulousDisassembly.index)
	
	if result then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then 
			SendNotification("meticulousDisassembly")
		end
	elseif result == nil then

		SendWarning("meticulousDisassembly")
	end
end

-------------------------------------------------------------------------------------------------
-- Fishing --
-------------------------------------------------------------------------------------------------
local delay = 2000 -- Delay so we don't have to check if we need to change CP 200 times a second

local function StartFishing()
	if not JackOfAllTrades.savedVariables.enable.reelTechnique and not JackOfAllTrades.savedVariables.enable.anglersInstinct then return end
	local reelTechniqueResult = false
	local anglersInstinctResult = false
	if JackOfAllTrades.savedVariables.enable.reelTechnique then 
		reelTechniqueResult = JackOfAllTrades.AddCPNodeToQueue(reelTechnique.id, GetDesiredSlot(reelTechnique.id, anglersInstinct.id, reelTechnique.index))
	end
	if JackOfAllTrades.savedVariables.enable.anglersInstinct then 
		anglersInstinctResult = JackOfAllTrades.AddCPNodeToQueue(anglersInstinct.id, GetDesiredSlot(anglersInstinct.id, reelTechnique.id, anglersInstinct.index))
	end
	if reelTechniqueResult or anglersInstinctResult then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then
			if reelTechniqueResult then SendNotification("reelTechnique") end
			if anglersInstinctResult then SendNotification("anglersInstinct") end
		end
	end
	if reelTechniqueResult == nil then SendWarning("reelTechnique") end
	if anglersInstinctResult == nil then SendWarning("anglersInstinct") end
end

local trashPots = {
	'|H0:item:27038:307:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h',
	'|H0:item:27037:307:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h',
	'|H0:item:27036:307:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h'
}

local function isTrashPotion(itemLink)
	for _, link in pairs(trashPots) do
		if link == itemLink then return true end
	end
	return false
end

local function QuickSlotChanged(e, slot)
	itemLink = GetSlotItemLink(slot)

	-- Trash pot check
	if not JackOfAllTrades.savedVariables.slotLeTrashPots and isTrashPotion(itemLink) then return false end

	consumableType, _ = GetItemLinkItemType(itemLink)
	-- Check if we need to do anything
	if consumableType ~= ITEMTYPE_FOOD and consumableType ~= ITEMTYPE_DRINK and consumableType ~= ITEMTYPE_POTION and consumableType ~= ITEMTYPE_POTION_BASE then return false end
	if not JackOfAllTrades.savedVariables.enable.rationer and not JackOfAllTrades.savedVariables.enable.liquidEfficiency then return end

	local rationerResult = false
	local liquidEfficiencyResult = false

	if JackOfAllTrades.savedVariables.enable.rationer and (consumableType == ITEMTYPE_FOOD or consumableType == ITEMTYPE_DRINK) then
		rationerResult = JackOfAllTrades.AddCPNodeToQueue(rationer.id, rationer.index)
	end

	if JackOfAllTrades.savedVariables.enable.liquidEfficiency and (consumableType == ITEMTYPE_POTION or consumableType == ITEMTYPE_POTION_BASE) then
		liquidEfficiencyResult = JackOfAllTrades.AddCPNodeToQueue(liquidEfficiency.id, liquidEfficiency.index)
	end

	if rationerResult or liquidEfficiencyResult then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then 
			if rationerResult then SendNotification("rationer") end
			if liquidEfficiencyResult then SendNotification("liquidEfficiency") end
		end
	end	

	if rationerResult == nil then SendWarning("rationer") end
	if liquidEfficiencyResult == nil then SendWarning("liquidEfficiency") end
end


local function MountStateChanged(e, mounted)
	if not mounted then return end

	if not JackOfAllTrades.savedVariables.enable.giftedRider and not JackOfAllTrades.savedVariables.enable.warMount then return end

	local giftedRiderResult = false
	local warMountResult = false

	if JackOfAllTrades.savedVariables.enable.giftedRider then
		giftedRiderResult = JackOfAllTrades.AddCPNodeToQueue(giftedRider.id, giftedRider.index)
	end

	if JackOfAllTrades.savedVariables.enable.warMount then
		warMountResult = JackOfAllTrades.AddCPNodeToQueue(warMount.id, warMount.index)
	end 

	if giftedRiderResult or warMountResult then
		local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
		if slotResult ~= false then
			if giftedRiderResult then SendNotification("giftedRider") end
			if warMountResult then SendNotification("warMount") end
		end
	end

	if giftedRiderResult == nil then SendWarning("giftedRider") end
	if warMountResult == nil then SendWarning("warMount") end
end

local function IsHomemakerBenefical(text)
	local homemakerSlottables = {
		SI_JACK_OF_ALL_TRADES_HM_BACKPACK,
		SI_JACK_OF_ALL_TRADES_HM_BARREL,
		SI_JACK_OF_ALL_TRADES_HM_BARRELS,
		SI_JACK_OF_ALL_TRADES_HM_BASKET,
		SI_JACK_OF_ALL_TRADES_HM_CHEST,
		SI_JACK_OF_ALL_TRADES_HM_CRATE,
		SI_JACK_OF_ALL_TRADES_HM_CRATES,
		SI_JACK_OF_ALL_TRADES_HM_CUPBOARD,
		SI_JACK_OF_ALL_TRADES_HM_DRAWERS,
		SI_JACK_OF_ALL_TRADES_HM_NIGHTSTAND,
		SI_JACK_OF_ALL_TRADES_HM_URN,
		SI_JACK_OF_ALL_TRADES_HM_WARDROBE,
		SI_JACK_OF_ALL_TRADES_HM_DRESSER,
		SI_JACK_OF_ALL_TRADES_HM_DESK,
		SI_JACK_OF_ALL_TRADES_HM_TRUNK,
		SI_JACK_OF_ALL_TRADES_HM_CABINET,
		SI_JACK_OF_ALL_TRADES_HM_D_JUG,
		SI_JACK_OF_ALL_TRADES_HM_D_JUG_L,
		SI_JACK_OF_ALL_TRADES_HM_D_POT,
		SI_JACK_OF_ALL_TRADES_HM_THIEVES_T,
		SI_JACK_OF_ALL_TRADES_HM_SAFEBOX,
		SI_JACK_OF_ALL_TRADES_HM_COFFER
	}

	for _, item in pairs(homemakerSlottables) do
		if text == GetString(item) then return true end
	end
end

function JackOfAllTrades.getHomemakerLootables()
	local homemakerSlottables = {
		SI_JACK_OF_ALL_TRADES_HM_BACKPACK,
		SI_JACK_OF_ALL_TRADES_HM_BARREL,
		SI_JACK_OF_ALL_TRADES_HM_BARRELS,
		SI_JACK_OF_ALL_TRADES_HM_BASKET,
		SI_JACK_OF_ALL_TRADES_HM_CHEST,
		SI_JACK_OF_ALL_TRADES_HM_CRATE,
		SI_JACK_OF_ALL_TRADES_HM_CRATES,
		SI_JACK_OF_ALL_TRADES_HM_CUPBOARD,
		SI_JACK_OF_ALL_TRADES_HM_DRAWERS,
		SI_JACK_OF_ALL_TRADES_HM_NIGHTSTAND,
		SI_JACK_OF_ALL_TRADES_HM_URN,
		SI_JACK_OF_ALL_TRADES_HM_WARDROBE,
		SI_JACK_OF_ALL_TRADES_HM_DRESSER,
		SI_JACK_OF_ALL_TRADES_HM_DESK,
		SI_JACK_OF_ALL_TRADES_HM_TRUNK,
		SI_JACK_OF_ALL_TRADES_HM_CABINET,
		SI_JACK_OF_ALL_TRADES_HM_D_JUG,
		SI_JACK_OF_ALL_TRADES_HM_D_JUG_L,
		SI_JACK_OF_ALL_TRADES_HM_D_POT,
		SI_JACK_OF_ALL_TRADES_HM_THIEVES_T,
		SI_JACK_OF_ALL_TRADES_HM_SAFEBOX,
		SI_JACK_OF_ALL_TRADES_HM_COFFER
	}
	output = ''
	for _, text in pairs(homemakerSlottables) do
		output = output .. '\n' .. GetString(text)
	end
	return output
end

-------------------------------------------------------------------------------------------------
-- When the player looks at something they can interact with, i.e. A crafting/ fishing node --
-------------------------------------------------------------------------------------------------
-- Pre Hook for whenever the player presses the interact key
local function OnInteractKeyPressed() 

	local zoneId, _, _, _ =  GetUnitWorldPosition('player')

	local interactText, mainText, looted, isOwned, additionalInfo, _, _, _ = GetGameCameraInteractableActionInfo()
	-- FISHING
	if additionalInfo == ADDITIONAL_INTERACT_INFO_FISHING_NODE then StartFishing() return end
	-- GATHERING
	if (interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_COLLECT) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_CUT) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_MINE) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_HARVEST)) then 
		if zoneId == 1197 then return false end -- Check if we are in Stone Garden, if we are we don't want to slot gathering passives.
		StartGathering() 
	-- TREASURE HUNTER
	elseif interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_UNLOCK) or ((mainText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_CHEST) or mainText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_CHEST_HIDDEN)) and interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_USE)) then 
		if not isOwned then -- This is to stop it slotting on doors.
			StartOpeningChest()
		end
	-- PICKPOCKETTING
	elseif interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_PICKPOCKET) then 
		StartPickpocketing()
	-- LOOTING
	else
		if (interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_SEARCH) or interactText == GetString(SI_JACK_OF_ALL_TRADES_INTERACT_STEALFROM)) and mainText ~= "Bookshelf" and not looted then
			if JackOfAllTrades.savedVariables.homemakerCorpses then
				StartLooting()
			else
				if IsHomemakerBenefical(mainText) then
					StartLooting()
				end
			end
		end
	end
end

local function SlotThInDungeon()
	if JackOfAllTrades.savedVariables.slotThInDungeon then
		if JackOfAllTrades.savedVariables.thHmPair then SlotThHmPair() return false end
		if not JackOfAllTrades.savedVariables.enable.treasureHunter then return false end
		local result = JackOfAllTrades.AddCPNodeToQueue(treasureHunter.id, treasureHunter.index)
		if result then
			local slotResult = JackOfAllTrades.SlotAllStarsInQueue()
			if slotResult ~= false then
				SendNotification("treasureHunter")
			end
		elseif result == nil then
			SendWarning("treasureHunter")
		end
	end
end

local function OnPlayerActivated(_, _)
	if IsUnitInDungeon('player') then SlotThInDungeon() end
end

local function LoadInSavedVariables()
	for star, index in pairs(JackOfAllTrades.savedVariables.slotIndex) do
		skillData[star].index = index
	end
	professionalUpkeep = skillData.professionalUpkeep
	meticulousDisassembly = skillData.meticulousDisassembly
	masterGatherer = skillData.masterGatherer
	plentifulHarvest = skillData.plentifulHarvest
	treasureHunter = skillData.treasureHunter
	homemaker = skillData.homemaker
	reelTechnique = skillData.reelTechnique
	anglersInstinct = skillData.anglersInstinct
	cutpursesArt = skillData.cutpursesArt
	infamous = skillData.infamous
	rationer = skillData.rationer
	liquidEfficiency = skillData.liquidEfficiency
	giftedRider = skillData.giftedRider
	warMount = skillData.warMount
end

function JackOfAllTrades.UpdateSkillSlots()
	LoadInSavedVariables()
end

-------------------------------------------------------------------------------------------------
-- Register for events, we only want to do so if the API version is high enough  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.InitEvents()
	LoadInSavedVariables()

	EM:RegisterForEvent(name, EVENT_OPEN_STORE, OpenStore)
	EM:RegisterForEvent(name, EVENT_CRAFTING_STATION_INTERACT, OpenCraftingStation)
	EM:RegisterForEvent(name, EVENT_OPEN_FENCE, OpenFence)
	EM:RegisterForEvent(name, EVENT_ACTIVE_QUICKSLOT_CHANGED, QuickSlotChanged)

	EM:RegisterForEvent(name, EVENT_MOUNTED_STATE_CHANGED, MountStateChanged)

	-- Is called whenever you press 'E'
	-- For fishing, treasureHunter, gathering nodes etc.
	ZO_PreHook(FISHING_MANAGER, "StartInteraction", OnInteractKeyPressed)


	-- To check if the player is in a dungeon, so we can automatically slot Treasure Hunter, if required
	EM:RegisterForEvent(name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
end
