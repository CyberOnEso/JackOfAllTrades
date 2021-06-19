-------------------------------------------------------------------------------------------------
-- Load in global variables --
-------------------------------------------------------------------------------------------------
JackOfAllTrades = {
	name = "JackOfAllTrades",
	author = '@CyberOnEso, @MMasing',
	version = '1.2.12',
	requiredAPIVersion = 100035
}

JackOfAllTrades.colours = {
	greenCP = "|c557C29",
	author = "|c5959D5"
}

local name = JackOfAllTrades.name
local EM = EVENT_MANAGER

-- Constants from the game
local CP = CHAMPION_PERKS
local championBar = CHAMPION_PERKS.championBar
local CPData = CHAMPION_DATA_MANAGER

-- Time in milliseconds that the player has to wait between assigning CP stars
local CP_COOLDOWN = 30000
local currentCPCooldown = 30

JackOfAllTrades.isOnCooldown = false

-- If the user is waiting for the cooldown to end then we can assign the queued CP after the cooldown ends
local isWaitingForCooldownToEnd = false

function JackOfAllTrades.GetCurrentCooldown()
	return currentCPCooldown 
end

local function EndCooldown()
	if not JackOfAllTrades.isOnCooldown then return false end
	currentCPCooldown = 0 
	JackOfAllTrades.isOnCooldown = false 

	if JackOfAllTrades.savedVariables.altertedAlwaysAfterCooldownOver then 
		JackOfAllTrades.sendCooldownOverMessage()
	end

	EVENT_MANAGER:UnregisterForUpdate(JackOfAllTrades.name.."CooldownTimer") 

	if JackOfAllTrades.savedVariables.debug then d("Cooldown over") end
	-- If we are waiting for the cooldown to end to slot skills we can slot them now.
	if isWaitingForCooldownToEnd then
		JackOfAllTrades.SlotAllStarsInQueue()
	end

	return true
end

local function StartCooldown() 
	-- If we are already on cooldown then we don't want to start the countdown again
	if JackOfAllTrades.isOnCooldown == true then return false end

	JackOfAllTrades.isOnCooldown = true
	-- currentCPCooldown will be set to 30s
	currentCPCooldown = CP_COOLDOWN/1000

	-- Start counting down from 30 to 0
	EVENT_MANAGER:RegisterForUpdate(JackOfAllTrades.name.."CooldownTimer", 1000, function() 
		currentCPCooldown = currentCPCooldown - 1
		-- If the cooldown is over
		if currentCPCooldown <= 0 then 
			EndCooldown()
		end
	end)
	return true
end



-- The current skill queue, since we only want to ever slot two stars at a time it is two long.
-- It stores both the skillId's and the skillIndexes
local skillQueue = {
	[3] = nil,
	[4] = nil
}

local function resetSkillQueue()
	skillQueue = {
		[3] = nil,
		[4] = nil
	}
end

JackOfAllTrades.resetSkillQueue = resetSkillQueue

local function isSkillQueueEmpty()
	local isEmpty = true
	for _, skillId in pairs(skillQueue) do
		if skillId ~= nil then isEmpty = false end
	end
	return isEmpty
end

function JackOfAllTrades.SlotAllStarsInQueue()
	if isSkillQueueEmpty() then return false end -- If the skill queue is empty we don't want to do anything

	if JackOfAllTrades.isOnCooldown then 
		isWaitingForCooldownToEnd = true
		return nil 
	end

	PrepareChampionPurchaseRequest(false) -- We don't need to spend gold on this respec so we pass in false

	for skillIndex, skillId in pairs(skillQueue) do -- Itterate across the skillQueue list
		AddHotbarSlotToChampionPurchaseRequest(skillIndex, skillId)
		if JackOfAllTrades.savedVariables.debug then d(skillId .. " added to the slot request in position " .. skillIndex) end
	end
	local championPurchaseAvailability = GetChampionPurchaseAvailability()
	local expectedResultForChampionPurchaseRequest = GetExpectedResultForChampionPurchaseRequest()
	-- If ZOS is telling us we shouldn't get errors from this purchase, then we can make it.
	if championPurchaseAvailability == 0 and expectedResultForChampionPurchaseRequest == 0 then

		JackOfAllTrades.SendQueuedNotifcations()
		SendChampionPurchaseRequest()
		resetSkillQueue()
		--if currentCPCooldown == 30 then JackOfAllTrades.isOnCooldown = true end
		return true
	else
		return false
	end
end

function JackOfAllTrades.GetSkillQueue()
	return skillQueue
end

-- Checks to see if the CP skill is slotted, only checks the green CP slots.
local function isCPSlotted(skillId)
	for index=1, 4 do
		if GetSlotBoundId(index, HOTBAR_CATEGORY_CHAMPION) == skillId then
			if JackOfAllTrades.savedVariables.debug then d("Skill is already slotted so won't reallocate it") end
			return true
		end
	end
	return false
end

local function RequiredPoints(championSkillId)
	if not DoesChampionSkillHaveJumpPoints(championSkillId) then return 1 end
	local firstJumpPoint
	_, firstJumpPoint = GetChampionSkillJumpPoints(championSkillId)
	return firstJumpPoint
end


-- Adds the CP node the the queue of stars to be slotted, when the player is off cooldown these stars can be slotted
function JackOfAllTrades.AddCPNodeToQueue(skillId, skillIndex)
	-- Check if it is a valid skillIndex
	if skillIndex ~= 1 and skillIndex ~= 2 and skillIndex ~= 3 and skillIndex ~= 4 then d("Skill needs to be added to either index 3 or 4") return false end

	-- Check if the skill is already slotted
	if isCPSlotted(skillId) then return false end

	-- Check if we have enough points in the star to slot it
	--if not CPData:GetChampionSkillData(skillId):CanBeSlotted() then return nil end
	if GetNumPointsSpentOnChampionSkill(skillId) < RequiredPoints(skillId) then return nil end

	-- Check if the skill already exists in the queue
	for _, id in pairs(skillQueue) do
		if id == skillIndex then d("Skill already exists in the queue") return false end
	end	

	-- Assign the skill the relevant position in the queue
	skillQueue[skillIndex] = skillId
	if JackOfAllTrades.savedVariables.debug then d(skillId .. ' added to the queue to be in position ' ..  skillIndex) end
	return true
end

local modifiedHotbar = false

local function ChampionPurchase(e, result)
	if result ~= 0 then return end

	if JackOfAllTrades.savedVariables.debug then d("Champion points slotted successfully") end

	-- If the user hasn't mofied the hotbar then they shouldn't go on cooldown and we shouldn't care about it.
	if not modifiedHotbar then return false end

	modifiedHotbar = false

	if JackOfAllTrades.savedVariables.debug then d("Cooldown started") end

	StartCooldown()
end

-------------------------------------------------------------------------------------------------
-- Initialize --
-------------------------------------------------------------------------------------------------
local function Initialize()
	JackOfAllTrades.InitSavedVariables()

	JackOfAllTrades:InitMenu()

	JackOfAllTrades.InitEvents()

	EVENT_MANAGER:UnregisterForEvent(name, EVENT_ADD_ON_LOADED)
end


-------------------------------------------------------------------------------------------------
-- When addon is first loaded --
-------------------------------------------------------------------------------------------------
function AddonLoaded(e, addonName)
	if addonName ~= name then return end

	Initialize()
end

local oldZoneId = 0

local function DidZoneChange()
	newZoneId = GetZoneId(GetUnitZoneIndex('player'))
	if newZoneId == oldZoneId then
		return false
	end
	oldZoneId = GetZoneId(GetUnitZoneIndex('player'))
	return true
end

local function PlayerActivated()
	if DidZoneChange() then
		EndCooldown()
	end
end

EM:RegisterForEvent(name, EVENT_ADD_ON_LOADED, AddonLoaded)
EM:RegisterForEvent(name, EVENT_CHAMPION_PURCHASE_RESULT, ChampionPurchase)
EM:RegisterForEvent(name, EVENT_PLAYER_ACTIVATED, PlayerActivated)

-- Whenever the user confirms reassining champion points via the ingame GUI
ZO_PreHook(CHAMPION_PERKS, "SpendPointsConfirmed", function()

	if JackOfAllTrades.isOnCooldown then 
		if JackOfAllTrades.savedVariables.showCooldownError then 
			ZO_Alert(ERROR, SOUNDS.GENERAL_ALERT_ERROR ,"You are on cooldown, please try again in ".. currentCPCooldown .. " seconds.")
			return true
		end
		--modifiedHotbar = false
		return false
	end
	
	return false
end)


ZO_PreHook("AddHotbarSlotToChampionPurchaseRequest", function () 
	modifiedHotbar = true
	return false
end)




-- Fix for a bug introduced in 6.3.4 where it will throw an error whenever we open the CP menu after allocating a CP node not via the GUI
-- This will, however, disable the weird camera wobble whenever you confirm a skill... which is good? As it looks terrible
ZO_PreHook(CHAMPION_PERKS, "OnUpdate", function() 
	CHAMPION_PERKS.firstStarConfirm = false
	return false
end)