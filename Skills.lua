JackOfAllTrades.SkillData = {
	-------------------------------------------------------------------------------------------------
	-- Constants for Meticulous Dissambly --
	-------------------------------------------------------------------------------------------------
	meticulousDisassembly = {
		id = 83,
		skillIndexToReplace = 1,
		stations = {1,2,6,7}
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Treasure Hunter --
	-------------------------------------------------------------------------------------------------
	treasureHunter = {
		id = 79,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Gifted Rider --
	-------------------------------------------------------------------------------------------------
	giftedRider = {
		id = 92,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for War Mount --
	-------------------------------------------------------------------------------------------------
	warMount = {
		id = 82,
		skillIndexToReplace = 2
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Professional Upkeep --
	-------------------------------------------------------------------------------------------------
	professionalUpkeep = {
		id = 1,
		skillIndexToReplace = 1
	},
	-------------------------------------------------------------------------------------------------
	-- Constants for Sustaining Shadows --
	-------------------------------------------------------------------------------------------------
	sustainingShadows = {
		id = 65,
		skillIndexToReplace = 1
	}
}

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

-------------------------------------------------------------------------------------------------
-- If we need to slot the node and that we have enough points into the skill then slot it  --
-------------------------------------------------------------------------------------------------
local function AttemptToSlot(self)
	-- If the skill is already slotten then we don't need to do anything.
	if self:isCPSkillSlotted() then 
		if JackOfAllTrades.savedVariables.debug then d(string.format("%s is already slotted so we don't need to do anything.", self.name)) end
		return true 
	end
	-- We don't want to redistrube someone's champion points and make them spend 3000 gold everytime they interact with a crafting station, that is not a good idea at all.
	--if GetNumPointsSpentOnChampionSkill(self.id) < self.requiredPoints then 
	if not CPData:GetChampionSkillData(self.id):CanBeSlotted() then
		if JackOfAllTrades.savedVariables.debug then d(string.format("You not have enough points in %s for us to slot it.", self.name)) end
		return 1 
	end
	-- If they have a node already in that slot save it so we can restore it later.
	if championBar:GetSlot(self.skillIndexToReplace).championSkillData and not self.isOldSkill then
		local oldSkill = {
			id = championBar:GetSlot(self.skillIndexToReplace).championSkillData:GetId(),
			skillIndexToReplace = self.skillIndexToReplace,
			isOldSkill = true
		}
		self.oldSkill = JackOfAllTrades.CreateCPData(oldSkill)
		JackOfAllTrades.savedVariables.oldSkill[self.skillIndexToReplace] = self.oldSkill.id
	end
	if self:slotCPNode() then
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
	if JackOfAllTrades.savedVariables.oldSkill[self.skillIndexToReplace] then
		-- CreateCPData for the old skill we want to slot, then attempt to slot it
		if JackOfAllTrades.CreateCPData({id = JackOfAllTrades.savedVariables.oldSkill[self.skillIndexToReplace], skillIndexToReplace = self.skillIndexToReplace}):AttemptToSlot() then
			if JackOfAllTrades.savedVariables.debug then d(string.format("%s removed.", GetChampionSkillName(self.id))) end
			-- Now we know the swap was successful we can remove the old skill from savedVariables.
			JackOfAllTrades.savedVariables.oldSkill[self.skillIndexToReplace] = nil
		end
		return true
	else
		if JackOfAllTrades.savedVariables.debug then d(string.format("No old skill found for %s, will not attempt to slot one.", self.name)) end
		return false
	end
end

-------------------------------------------------------------------------------------------------
-- If we need to slot a skill after combat ends  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.whenCombatEndsSlotSkill(eventcode, inCombat)
	if inCombat then return end
	local successful = false
	for skillIndex, skillId in pairs(JackOfAllTrades.savedVariables.oldSkill) do
		if skillId then
			if JackOfAllTrades.savedVariables.debug then d(string.format("Attempting to slot %s as combat has ended.", GetChampionSkillName(skillId))) end
			local oldSkillData = {
				id = skillId,
				skillIndexToReplace = skillIndex
			}
			local oldSkill = JackOfAllTrades.CreateCPData(oldSkillData)
			if oldSkill:AttemptToSlot() then successful = true end
		end
	end
	if successful == true then 
		if JackOfAllTrades.savedVariables.debug then d(string.format("Unregistered from the out of combat event.")) end
		JackOfAllTrades.savedVariables.inCombatDuringReloadUI = false
		EVENT_MANAGER:UnregisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_COMBAT_STATE)
	end
end

-------------------------------------------------------------------------------------------------
-- Slots the CP node if we pass the checks by ZOS  --
-------------------------------------------------------------------------------------------------
local function slotCPNode(self)
	PrepareChampionPurchaseRequest(false)
	AddHotbarSlotToChampionPurchaseRequest(self.skillIndexToReplace, self.id)
	local championPurchaseAvailability = GetChampionPurchaseAvailability()
	local expectedResultForChampionPurchaseRequest = GetExpectedResultForChampionPurchaseRequest()
	if championPurchaseAvailability == 0 and expectedResultForChampionPurchaseRequest == 0 then
		SendChampionPurchaseRequest()
		return true
	else
		-- If we are in combat then we cannot slot a CP node, so we will wait until we are out of combat to try again.
		if expectedResultForChampionPurchaseRequest == CHAMPION_PURCHASE_IN_COMBAT then
			JackOfAllTrades.savedVariables.oldSkill[self.skillIndexToReplace] = self.id
			if JackOfAllTrades.savedVariables.debug then d(string.format("Registered %s to be slotted in slot: %s when combat ends", self.name, self.skillIndexToReplace)) end
			EVENT_MANAGER:RegisterForEvent(JackOfAllTrades.name, EVENT_PLAYER_COMBAT_STATE, JackOfAllTrades.whenCombatEndsSlotSkill)
			-- If we reload ui when in combat, for some reason... IDFK why this may be taking it to the nth degree. But y'know Cyrodiil keep you in combat forever..
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
local function RequiredPoints(championSkillId)
	if not DoesChampionSkillHaveJumpPoints(championSkillId) then return 1 end
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
		if championBar:GetSlot(i).championSkillData then
			if championBar:GetSlot(i).championSkillData:GetId() == self.id then
				return true
			end
		end
	end
	return false
end

-------------------------------------------------------------------------------------------------
-- Constructor  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.CreateCPData(championSkillData)
	return {
	name = GetChampionSkillName(championSkillData.id),
	id = championSkillData.id,
	disciplineIndex = CPData:GetChampionSkillData(championSkillData.id):GetChampionDisciplineData().disciplineIndex,
	requiredPoints = RequiredPoints(championSkillData.Id),
	skillIndexToReplace = championSkillData.skillIndexToReplace,
	oldSkill = nil,
	isOldSkill = championSkillData.isOldSkill,

	-- Assign the utility functions
	AttemptToSlot = AttemptToSlot,
	AttemptToReturnSlot = AttemptToReturnSlot,
	isCPSkillSlotted = isCPSkillSlotted,
	slotCPNode = slotCPNode,
	slotOldCPNode = slotOldCPNode,
	}
end

-------------------------------------------------------------------------------------------------
-- Load in all the CP skill data we need  --
-------------------------------------------------------------------------------------------------
local function LoadInSkills()
	JackOfAllTrades.meticulousDisassembly = JackOfAllTrades.CreateCPData(JackOfAllTrades.SkillData.meticulousDisassembly)
	JackOfAllTrades.treasureHunter = JackOfAllTrades.CreateCPData(JackOfAllTrades.SkillData.treasureHunter)
	JackOfAllTrades.giftedRider = JackOfAllTrades.CreateCPData(JackOfAllTrades.SkillData.giftedRider)
	JackOfAllTrades.warMount = JackOfAllTrades.CreateCPData(JackOfAllTrades.SkillData.warMount)
	JackOfAllTrades.professionalUpkeep = JackOfAllTrades.CreateCPData(JackOfAllTrades.SkillData.professionalUpkeep)
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
-- Setup some constants and load in the skill  --
-------------------------------------------------------------------------------------------------
function JackOfAllTrades.InitSkills()
	-- Load the stations that Meticulous Disassembly works with globally so we can check for it in Events.lua
	JackOfAllTrades.meticulousDisassemblyStations =  JackOfAllTrades.SkillData.meticulousDisassembly.stations

	LoadInSkills()
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