-------------------- * --------------------
-- for more info and examples check the GitHub wiki
-- https://github.com/BellinRattin/
-------------------- * --------------------

local MAJOR, MINOR = "LibEasyAlerts", 1
local LEA = LibStub:NewLibrary(MAJOR, MINOR)

if not LEA then return end

local DEFAULT_EMPTY_STRING = ""
local DEFAULT_ICON = [[Interface\Icons\Inv_misc_coin_01]]
local SHIELD_POINTS = [[Interface\AchievementFrame\UI-Achievement-Shields]]
local SHIELD_NO_POINTS = [[Interface\AchievementFrame\UI-Achievement-Shields-NoPoints]]

----------------------------------------
-- from Blizzard's
--  * FrameXML/AlertFrameSystems.lua
--  * FrameXML/AlertFrames.lua        
--modified as needed
----------------------------------------

local Helper = {}

--item can be itemID or "itemString" or "itemName" or "itemLink"
function Helper.GetIconFromItem(item) 
	_, _, _, _, icon, _, _ = GetItemInfoInstant(item) 
	return icon
end
function Helper.GetNameFromItem(item)
	name = GetItemInfo(item) 
	return name
end
function Helper.GetLinkFromItem(item)
	_, link = GetItemInfo(item) 
	return link
end

--spell can be spellID or spellLink or SpellName
function Helper.GetIconFromSpell(spell) 
	_, _, icon = GetSpellInfo(spell)
	return icon
end

function Helper.GetNameFromSpell(spell) 
	name = GetSpellInfo(spell)
	return name
end

function Helper.GetIconFromAchievement(achievementID) 
	_, _, _, _, _, _, _, _, _, icon= GetAchievementInfo(achievementID)
	return icon
end

function Helper.GetNameFromAchievement(achievementID) 
	_, name= GetAchievementInfo(achievementID)
	return name
end

local function LEAFrame_OnClick (self, button, down)
	if self.onClickFunction then
		self.onClickFunction()
	end
end

---------------------------------------- Achievement ----------------------------------------
local function Achievement_SetUp(frame, icon, name, points, unlocked, onClickFunction )

	local frameIconTexture = frame.Icon.Texture
	local frameUnlocked = frame.Unlocked
	local frameName = frame.Name
	local frameShieldPoints = frame.Shield.Points
	local frameShieldIcon = frame.Shield.Icon

	local icon = icon or DEFAULT_ICON
	local points = points or 0
	local name = name or DEFAULT_EMPTY_STRING
	local unlocked = unlocked or DEFAULT_EMPTY_STRING

	frameIconTexture:SetTexture(icon or DEFAULT_ICON)
	frameUnlocked:SetText(unlocked)
	frameName:SetText(name)

	if points == 0 then
		frameShieldIcon:SetTexture(SHIELD_NO_POINTS)
		frameShieldPoints:SetText(DEFAULT_EMPTY_STRING)
	else
		frameShieldIcon:SetTexture(SHIELD_POINTS)
		if points < 100 then
			frameShieldPoints:SetFontObject(GameFontNormal)
		else
			frameShieldPoints:SetFontObject(GameFontNormalSmall)
		end
		frameShieldPoints:SetText(points)
	end

	frameShieldPoints:Show()
	frameShieldIcon:Show()

	frame:SetScript("OnClick", function(...)
		if onClickFunction then
			onClickFunction(...)
		end
	end)

	return true
end

local AchievementAS = AlertFrame:AddQueuedAlertFrameSubSystem("AchievementAlertFrameTemplate", Achievement_SetUp, 2, 6)
AchievementAS:SetCanShowMoreConditionFunc(function() return not C_PetBattles.IsInBattle() end)

local function DisplayAchievement(unlocked, name, points, icon, onClickFunction)
	if (not AchievementFrame) then
		AchievementFrame_LoadUI()
	end
	AchievementAS:AddAlert(icon, name, points, unlocked, onClickFunction)
	PlaySound(12891) -- https://www.wowhead.com/sound=12891/ui-alert-achievementgained
end

---------------------------------------- Criteria ----------------------------------------
local function Criteria_SetUp(frame, icon, text, title)
	local icon = icon or DEFAULT_ICON
	local text = text or DEFAULT_EMPTY_STRING
	local title = title or DEFAULT_EMPTY_STRING

	frame.Name:SetText(text)
	frame.Icon.Texture:SetTexture(icon)
	frame.Unlocked:SetText(title)
end

local CriteriaAS = AlertFrame:AddQueuedAlertFrameSubSystem("CriteriaAlertFrameTemplate", Criteria_SetUp, 2, 0);

local function DisplayCriteria(text, title, icon)
	CriteriaAS:AddAlert(icon, text, title)
end

---------------------------------------- Others ----------------------------------------
local function Display(type, ...)
	if type == "Achievement" then
		DisplayAchievement(...)
	elseif type == "Criteria" then
		DisplayCriteria(...)
	end
end


---------------------------------------- Helpers ----------------------------------------
LEA.Helper = {}

-- Icon
function LEA.Helper.GetIconFromItem(item) return Helper.GetIconFromItem(item) end
function LEA.Helper.GetIconFromSpell(spell) return Helper.GetIconFromSpell(spell) end
function LEA.Helper.GetIconFromAchievement(achievement) return Helper.GetIconFromAchievement(achievement) end

-- Name
function LEA.Helper.GetNameFromItem(item) return Helper.GetNameFromItem(item) end
function LEA.Helper.GetNameFromSpell(spell) return Helper.GetNameFromSpell(spell) end
function LEA.Helper.GetNameFromAchievement(achievement) return Helper.GetNameFromAchievement(achievement) end

-- Link
function LEA.Helper.GetLinkFromItem(item) return Helper.GetLinkFromItem(item) end


---------------------------------------- Library Methods ----------------------------------------
function LEA:DisplayAchievement(...)
	DisplayAchievement(...)
end

function LEA:DisplayCriteria( ... )
	DisplayCriteria(...)
end

