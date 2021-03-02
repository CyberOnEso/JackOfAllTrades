-------------------------------------------------------------------------------------------------
-- Only return the CP constants if we are using CP 2.0 --
-------------------------------------------------------------------------------------------------
local function GetCPConstant()
	if GetAPIVersion() >= JackOfAllTrades.requiredAPIVersion then 
		return CHAMPION_PERKS
	else 
		return nil 
	end
end

local function GetChampionBar()
	if GetAPIVersion() >= JackOfAllTrades.requiredAPIVersion then 
		return CHAMPION_PERKS:GetChampionBar() 
	else 
		return nil 
	end 
end

-- We can use this to find everything out about a given championSkillId
-- By using CPData:GetChampionSkillData(championSkillId)
local function GetCPDataConstant()
	if GetAPIVersion() >= JackOfAllTrades.requiredAPIVersion then
		return CHAMPION_DATA_MANAGER
	else
		return nil
	end
end

-------------------------------------------------------------------------------------------------
-- CP constants from ZOS --
-------------------------------------------------------------------------------------------------
local CP = GetCPConstant()
local championBar = GetChampionBar()
local CPData = GetCPDataConstant()

local _, totalChampionBarSlots = GetAssignableChampionBarStartAndEndSlots()

local function getNumDisciplines()
	local numDisciplines = 0
	for _ in pairs(championBar.disciplineCallouts) do numDisciplines = numDisciplines + 1 end
	return numDisciplines
end

local numDisciplines = getNumDisciplines()

-------------------------------------------------------------------------------------------------
-- Main CP Utility Functions  --
-------------------------------------------------------------------------------------------------
local function isCPSkillSlotted(self)
	-- Gets either 1, 5, or 9 depending on which discipline we want to check in.
	local firstIndex = championBar.firstSlotPerDiscipline[GetChampionDisciplineId(self.disciplineIndex)]
	-- Itterates between the firstIndex of the segment of the bar we want to check and the last
	for i=firstIndex, firstIndex+(totalChampionBarSlots/numDisciplines) do
		if championBar:GetSlot(i).championSkillData then
			if championBar:GetSlot(i).championSkillData:GetId() == self.id then
				return true
			end
		end
	end
	return false
end

-- This just makes i
local slotInUse = nil
-- Returns the index for the first empty slot in a given discipline of the players championBar.
-- If the player doesn't have any slots return nil.
local function getFirstEmptySlot(disciplineIndex)
	local firstIndex = championBar.firstSlotPerDiscipline[GetChampionDisciplineId(disciplineIndex)] 
	for i=firstIndex, (firstIndex+(totalChampionBarSlots/numDisciplines))-1 do
		if i ~= slotInUse then 
			if not championBar:GetSlot(i).championSkillData then
				slotInUse = i
				return i
			end
		end
	end
	return nil
end

-------------------------------------------------------------------------------------------------
-- If we need to slot the node and that we have enough points into the skill then slot it  --
-------------------------------------------------------------------------------------------------
local function AttemptToSlot(self)
	-- If the skill is already slotted then we don't need to do anything.
	if self:isCPSkillSlotted() then 
		if JackOfAllTrades.savedVariables.debug then d(string.format("%s is already slotted so we don't need to do anything.", self.name)) end
		return false 
	end
	-- We don't want to redistrube someone's champion points and make them spend 3000 gold everytime they interact with a crafting station.
	if not CPData:GetChampionSkillData(self.id):CanBeSlotted() then
		if JackOfAllTrades.savedVariables.debug then d(string.format("You not have enough points in %s for us to slot it.", self.name)) end
		return nil -- In case they do not have enough points into the node, we can maybe use a pcall for this.
	end

	-- Short circuit logic, will set the slot to the first empty slot if there is one or to the primary slot if there isn't an empty slot.
	local skillIndexToReplace = getFirstEmptySlot(self.disciplineIndex) or JackOfAllTrades.savedVariables.skillIndexToReplace[self.skillIndexToReplace]

	if not self.isOldSkill then
		-- If they have a node already in that slot save it so we can restore it later.
		--local slotIndex = JackOfAllTrades.savedVariables.skillIndexToReplace[self.skillIndexToReplace]
		local slotIndex = skillIndexToReplace
		local oldSkillData = championBar:GetSlot(slotIndex).championSkillData
		if oldSkillData then
			--JackOfAllTrades.savedVariables.oldSkill[JackOfAllTrades.savedVariables.skillIndexToReplace[self.skillIndexToReplace]] = oldSkillData:GetId()
			JackOfAllTrades.savedVariables.oldSkill[skillIndexToReplace] = oldSkillData:GetId()
		end
	end
	-- Use a pcall for this in the future
	if self:slotCPNode(skillIndexToReplace) then
		if JackOfAllTrades.savedVariables.debug then d(string.format("%s added", self.name)) end
		return true
	else 
		return false
	end
end

-------------------------------------------------------------------------------------------------
-- If we need to reslot a node then do so  --
-------------------------------------------------------------------------------------------------
local function AttemptToReturnSlot(self)
	if JackOfAllTrades.savedVariables.oldSkill then
		local wasSlottingSuccessful = false
		for index, id in pairs(JackOfAllTrades.savedVariables.oldSkill) do
			local oldSkillData = {
				id = id, 
				skillIndexToReplace = index,
				isOldSkill = true
			}
			local oldSkill = JackOfAllTrades.CreateCPData(oldSkillData)
			-- Then we know we have an old skill which isn't currently slotted, so lets slot it
			if not oldSkill:isCPSkillSlotted() then 
				if oldSkill:AttemptToSlot() then
					if JackOfAllTrades.savedVariables.debug then d(string.format("%s added back to slot: %s.", ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(oldSkill.id)), oldSkill.skillIndexToReplace)) end
					-- Now we know the swap was successful we can remove the old skill from savedVariables.
					JackOfAllTrades.savedVariables.oldSkill[index] = nil
					wasSlottingSuccessful = true
				end
			end
		end
		if wasSlottingSuccessful then
			slotInUse = nil
			return true
		end
	end
	return false
end

-------------------------------------------------------------------------------------------------
-- If we need to slot a skill after combat ends  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.whenCombatEndsSlotSkill(eventcode, inCombat)
	if inCombat then return end
	-- successful will be true if we have returned a skill, therefore we can unregister from the combat event.
	local successful = false
	-- Itterates across all the old skills we have saved and attemts to slot each of them.
	for skillIndex, skillId in pairs(JackOfAllTrades.savedVariables.oldSkill) do
		if skillId then
			if JackOfAllTrades.savedVariables.debug then d(string.format("Attempting to slot %s as combat has ended.", ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(skillId)))) end
			local oldSkillData = {
				id = skillId,
				skillIndexToReplace = skillIndex,
				isOldSkill = true
			}
			local oldSkill = JackOfAllTrades.CreateCPData(oldSkillData)
			if oldSkill:AttemptToSlot() then successful = true end
		end
	end
	-- We have been able to slot the skills the player wanted back, so we no longer care about the combat state.
	if successful == true then 
		if JackOfAllTrades.savedVariables.debug then d(string.format("Unregistered from the out of combat event.")) end
		JackOfAllTrades.savedVariables.inCombatDuringReloadUI = false
		EVENT_MANAGER:UnregisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_COMBAT_STATE)
	end
end

-------------------------------------------------------------------------------------------------
-- Slots the CP node if we pass the checks by ZOS  --
-------------------------------------------------------------------------------------------------
local function slotCPNode(self, skillIndexToReplace)
	PrepareChampionPurchaseRequest(false) -- We don't need to spend gold on this respec so we pass in false
	if self.isOldSkill then 
		AddHotbarSlotToChampionPurchaseRequest(self.skillIndexToReplace, self.id) 
	else
		-- Short circuit logic, will set the slot to the first empty slot if there is one or to the primary slot if there isn't an empty slot.
		if skillIndexToReplace == nil then 
			skillIndexToReplace = JackOfAllTrades.savedVariables.skillIndexToReplace[self.skillIndexToReplace]
		end
		AddHotbarSlotToChampionPurchaseRequest(skillIndexToReplace, self.id) 
	end
	local championPurchaseAvailability = GetChampionPurchaseAvailability()
	local expectedResultForChampionPurchaseRequest = GetExpectedResultForChampionPurchaseRequest()
	-- If ZOS is telling us we shouldn't get errors from this purchase, then we can make it.
	if championPurchaseAvailability == 0 and expectedResultForChampionPurchaseRequest == 0 then
		SendChampionPurchaseRequest()
		return true
	else
		-- If we are in combat then we cannot slot a CP node, so we will wait until we are out of combat to try again.
		if expectedResultForChampionPurchaseRequest == CHAMPION_PURCHASE_IN_COMBAT and self.isOldSkill then
			JackOfAllTrades.savedVariables.oldSkill[skillIndexToReplace] = self.id
			if JackOfAllTrades.savedVariables.debug then d(string.format("Registered %s to be slotted in slot: %s when combat ends", self.name, skillIndexToReplace)) end
			-- This will be kept open until we can next slot a skill, i.e. when we are out of combat.
			EVENT_MANAGER:RegisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_COMBAT_STATE, JackOfAllTrades.whenCombatEndsSlotSkill)
			-- Ensures that the combat event will be reopened if we reloadui whilst in combat.
			JackOfAllTrades.savedVariables.inCombatDuringReloadUI = true
		end
		if JackOfAllTrades.savedVariables.debug then
			d(string.format("Couldn't slot %s because of reason number: %s", self.name, expectedResultForChampionPurchaseRequest))
		end
		return false
	end
end

-------------------------------------------------------------------------------------------------
-- Utility function to get the minimum number of points required to slot the skill  --
-------------------------------------------------------------------------------------------------
local function requiredPointsToSlot(championSkillId)
	-- If there are no jump points then we know that slotting 1 point into the skill we be enough for us to slot it.
	if not DoesChampionSkillHaveJumpPoints(championSkillId) then return 1 end
	-- If it does have jump points then we know that we can slot it by putting in only upto the first jump point worth of points.
	local firstJumpPoint
	_, firstJumpPoint = GetChampionSkillJumpPoints(championSkillId)
	return firstJumpPoint
end

-------------------------------------------------------------------------------------------------
-- Check if CP is slotted  --
-------------------------------------------------------------------------------------------------
local function isCPSkillSlotted(self)
	-- Gets either 1, 5, or 9 depending on which discipline we want to check in.
	local firstIndex = championBar.firstSlotPerDiscipline[GetChampionDisciplineId(self.disciplineIndex)]
	-- Itterates between the firstIndex of the segment of the bar we want to check and the last
	for i=firstIndex, firstIndex+(totalChampionBarSlots/numDisciplines) do
		if championBar:GetSlot(i).championSkillData then -- If anything is slotted into that index
			if championBar:GetSlot(i).championSkillData:GetId() == self.id then
				return true
			end
		end
	end
	return false
end

-------------------------------------------------------------------------------------------------
-- Change skill to repace  --
-------------------------------------------------------------------------------------------------
local function ChangeSkillCategory()
	-- Gets either 1, 5, or 9 depending on which discipline we want to check in.
	local firstIndex = championBar.firstSlotPerDiscipline[GetChampionDisciplineId(self.disciplineIndex)]
	if newSkillCategory <= firstIndex and newSkillCategory >= firstIndex+(totalChampionBarSlots/numDisciplines) then
		self.skillIndexToReplace = newSkillCategory
	end
end

function JackOfAllTrades.updateSkillCategory()
	ChangeSkillCategory
end

-------------------------------------------------------------------------------------------------
-- Constructor  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.CreateCPData(championSkillData)
	if JackOfAllTrades.savedVariables.category[championSkillData.rawName] then
		championSkillData.skillIndexToReplace = JackOfAllTrades.savedVariables.category[championSkillData.rawName]
	end
	return {
	name = ZO_CachedStrFormat(SI_CHAMPION_STAR_NAME, GetChampionSkillName(championSkillData.id)),
	id = championSkillData.id,
	disciplineIndex = CPData:GetChampionSkillData(championSkillData.id):GetChampionDisciplineData().disciplineIndex,
	requiredPointsToSlot = requiredPointsToSlot(championSkillData.Id),
	skillIndexToReplace = championSkillData.skillIndexToReplace,
	isOldSkill = championSkillData.isOldSkill,

	-- Assign the utility functions
	AttemptToSlot = AttemptToSlot,
	AttemptToReturnSlot = AttemptToReturnSlot,
	isCPSkillSlotted = isCPSkillSlotted,
	slotCPNode = slotCPNode,
	slotOldCPNode = slotOldCPNode,
	ChangeSkillCategory = ChangeSkillCategory
	}
end

-------------------------------------------------------------------------------------------------
-- Utilty function to slot a skill in the CP bar with a known id  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.AttemptToSlotId(championSkillId, skillIndexToReplace)
	local skillData = {
		id = championSkillId,
		skillIndexToReplace = skillIndexToReplace,
		isOldSkill = true
	}
	local skill = JackOfAllTrades.CreateCPData(skillData)
	skill:AttemptToSlot()
end

-------------------------------------------------------------------------------------------------
-- Workarounds, but if they work it's not a hack  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.OnReloadUI()
	-- This is work around because after a reload UI the championBar will not initilize until you open the CP menu
	-- Weirdly, it will initilize on first logon.
	CP:PerformDeferredInitializationShared()
end

-- Fix for a bug introduced in 6.3.4 where it will throw an error whenever we open the CP menu after allocating a CP node not via the GUI
-- This will, however, disable the weird camera wobble whenever you confirm a skill... which is good? As it looks terrible
ZO_PreHook(CHAMPION_PERKS, "OnUpdate", function() 
	CHAMPION_PERKS.firstStarConfirm = false
	return false
end)