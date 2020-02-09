
local ADDON_NAME, addon = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent)
end
addon = _G[ADDON_NAME]

addon:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

local debugf = tekDebug and tekDebug:GetFrame(ADDON_NAME)
local function Debug(...)
    if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end
end

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
local LibClassicDurations = LibStub("LibClassicDurations", true)

local isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local UnitAura = _G.UnitAura

--wrap the UnitAura function if addon is running in classic
--Aura does not provide duration or expiration in classic.
if not isRetail and LibClassicDurations then
    LibClassicDurations:Register("xanDebuffTimers")
    UnitAura = LibClassicDurations.UnitAuraWrapper
end

addon.timers = {}
addon.timersFocus = {}

--debuff arrays
addon.timers.debuffs = {}
addon.timersFocus.debuffs = {}

addon.MAX_TIMERS = 15

local ICON_SIZE = 20
local BAR_ADJUST = 25
--40 characters, each worth 2.5 out of 100, to get bar length.  (percent/2.5)  example: 75/2.5 = 30 bar length
local BAR_TEXT = "llllllllllllllllllllllllllllllllllllllll"
local band = bit.band
local locked = false

local targetGUID = 0
local focusGUID = 0
local UnitAura = UnitAura
local UnitIsUnit = UnitIsUnit
local UnitGUID = UnitGUID
local UnitName = UnitName

local timerList = {
	["target"] = addon.timers,
	["focus"] = addon.timersFocus,
}

local barsLoaded = false

----------------------
--      Enable      --
----------------------
	
function addon:PLAYER_LOGIN()

	if not XDT_DB then XDT_DB = {} end
	if XDT_DB.scale == nil then XDT_DB.scale = 1 end
	if XDT_DB.grow == nil then XDT_DB.grow = false end
	if XDT_DB.sort == nil then XDT_DB.sort = false end
	if XDT_DB.showInfinite == nil then XDT_DB.showInfinite = true end
	
	--create our anchors
	addon:CreateAnchor("XDT_Anchor", UIParent, L.BarTargetAnchor)
	if isRetail then
		addon:CreateAnchor("XDT_FocusAnchor", UIParent, L.BarFocusAnchor)
	end

	--create our bars
	addon:generateBars()
	
	addon:UnregisterEvent("PLAYER_LOGIN")
	addon.PLAYER_LOGIN = nil
	
	addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	addon:RegisterEvent("PLAYER_TARGET_CHANGED")
	if isRetail then
		addon:RegisterEvent("PLAYER_FOCUS_CHANGED")
	end

	SLASH_XANDEBUFFTIMERS1 = "/xdt"
	SlashCmdList["XANDEBUFFTIMERS"] = function(cmd)
	
		local a,b,c=strfind(cmd, "(%S+)"); --contiguous string of non-space characters
		
		if a then
			if c and c:lower() == L.SlashAnchor then
				addon.aboutPanel.btnAnchor.func()
				return true
			elseif c and c:lower() == L.SlashReset then
				addon.aboutPanel.btnReset.func()
				return true
			elseif c and c:lower() == L.SlashScale then
				if b then
					local scalenum = strsub(cmd, b+2)
					if scalenum and scalenum ~= "" and tonumber(scalenum) and tonumber(scalenum) > 0 and tonumber(scalenum) <= 200 then
						addon.aboutPanel.sliderScale.func(tonumber(scalenum))
					else
						DEFAULT_CHAT_FRAME:AddMessage(L.SlashScaleSetInvalid)
					end
					return true
				end
			elseif c and c:lower() == L.SlashGrow then
				addon.aboutPanel.btnGrow.func(true)
				return true
			elseif c and c:lower() == L.SlashSort then
				addon.aboutPanel.btnSort.func(true)
				return true
			elseif c and c:lower() == L.SlashReload then
				 addon.aboutPanel.btnReloadDebuffs.func()
				return true
			elseif c and c:lower() == L.SlashInfinite then
				addon.aboutPanel.btnInfinite.func(true)
				return true
			end
		end

		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME, 64/255, 224/255, 208/255)
		DEFAULT_CHAT_FRAME:AddMessage("/xdt "..L.SlashAnchor.." - "..L.SlashAnchorInfo)
		DEFAULT_CHAT_FRAME:AddMessage("/xdt "..L.SlashReset.." - "..L.SlashResetInfo)
		DEFAULT_CHAT_FRAME:AddMessage("/xdt "..L.SlashScale.." # - "..L.SlashScaleInfo)
		DEFAULT_CHAT_FRAME:AddMessage("/xdt "..L.SlashGrow.." - "..L.SlashGrowInfo)
		DEFAULT_CHAT_FRAME:AddMessage("/xdt "..L.SlashSort.." - "..L.SlashSortInfo)
		DEFAULT_CHAT_FRAME:AddMessage("/xdt "..L.SlashReload .." - "..L.SlashReloadInfo)
		DEFAULT_CHAT_FRAME:AddMessage("/xdt "..L.SlashInfinite.." - "..L.SlashInfiniteInfo)
	end
	
	local ver = GetAddOnMetadata(ADDON_NAME,"Version") or '1.0'
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r [v|cFF20ff20%s|r] loaded:   /xdt", ADDON_NAME, ver or "1.0"))
end
	
function addon:PLAYER_TARGET_CHANGED()
	if UnitName("target") and UnitGUID("target") then
		targetGUID = UnitGUID("target")
		addon:ProcessDebuffs("target")
	else
		addon:ClearDebuffs("target")
		targetGUID = 0
	end
end

function addon:PLAYER_FOCUS_CHANGED()
	if not isRetail then return end
	if UnitName("focus") and UnitGUID("focus") then
		focusGUID = UnitGUID("focus")
		addon:ProcessDebuffs("focus")
	else
		addon:ClearDebuffs("focus")
		focusGUID = 0
	end
end

local eventSwitch = {
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_REMOVED"] = true,
	["SPELL_AURA_REFRESH"] = true,
	["SPELL_AURA_APPLIED_DOSE"] = true,
	["SPELL_AURA_APPLIED_REMOVED_DOSE"] = true,
	["SPELL_AURA_REMOVED_DOSE"] = true,
	["SPELL_AURA_BROKEN"] = true,
	["SPELL_AURA_BROKEN_SPELL"] = true,
	["ENCHANT_REMOVED"] = true,
	["ENCHANT_APPLIED"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_PERIODIC_ENERGIZE"] = true,
	["SPELL_ENERGIZE"] = true,
	["SPELL_PERIODIC_HEAL"] = true,
	["SPELL_HEAL"] = true,
	["SPELL_DAMAGE"] = true,
	["SPELL_PERIODIC_DAMAGE"] = true,
	--added new
	["SPELL_DRAIN"] = true,
	["SPELL_LEECH"] = true,
	["SPELL_PERIODIC_DRAIN"] = true,
	["SPELL_PERIODIC_LEECH"] = true,
	["DAMAGE_SHIELD"] = true,
	["DAMAGE_SPLIT"] = true,
}

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

function addon:COMBAT_LOG_EVENT_UNFILTERED()

	--local timestamp, eventType, hideCaster, sourceGUID, sourceName, srcFlags, sourceRaidFlags, dstGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, auraType, amount
	local timestamp, eventType, _, sourceGUID, _, srcFlags, _, dstGUID = CombatLogGetCurrentEventInfo()

    if eventType == "UNIT_DIED" or eventType == "UNIT_DESTROYED" then
		--clear the debuffs if the unit died
		--NOTE the reason an elseif isn't used is because some dorks may have
		--their current target as their focus as well
		if dstGUID == targetGUID then
			addon:ClearDebuffs("target")
			targetGUID = 0
		end
		if isRetail and dstGUID == focusGUID then
			addon:ClearDebuffs("focus")
			focusGUID = 0
		end
		
	elseif eventSwitch[eventType] and band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 then
		--process the spells based on GUID
		if dstGUID == targetGUID then
			addon:ProcessDebuffs("target")
		end
		if isRetail and dstGUID == focusGUID then
			addon:ProcessDebuffs("focus")
		end
    end
end

----------------------
--  Frame Creation  --
----------------------

function addon:CreateAnchor(name, parent, desc)

	--create the anchor
	local frameAnchor = CreateFrame("Frame", name, parent)
	
	frameAnchor:SetWidth(25)
	frameAnchor:SetHeight(25)
	frameAnchor:SetMovable(true)
	frameAnchor:SetClampedToScreen(true)
	frameAnchor:EnableMouse(true)

	frameAnchor:ClearAllPoints()
	frameAnchor:SetPoint("CENTER", parent, "CENTER", 0, 0)
	frameAnchor:SetFrameStrata("DIALOG")
	
	frameAnchor:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frameAnchor:SetBackdropColor(0.75,0,0,1)
	frameAnchor:SetBackdropBorderColor(0.75,0,0,1)

	frameAnchor:SetScript("OnLeave",function(self)
		GameTooltip:Hide()
	end)

	frameAnchor:SetScript("OnEnter",function(self)
	
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(self:SetTip(self))
		GameTooltip:ClearLines()
		
		GameTooltip:AddLine(name)
		if desc then
			GameTooltip:AddLine(desc)
		end
		GameTooltip:Show()
	end)

	frameAnchor:SetScript("OnMouseDown", function(frame, button)
		if frame:IsMovable() then
			frame.isMoving = true
			frame:StartMoving()
		end
	end)

	frameAnchor:SetScript("OnMouseUp", function(frame, button) 
		if( frame.isMoving ) then
			frame.isMoving = nil
			frame:StopMovingOrSizing()
			addon:SaveLayout(frame:GetName())
		end
	end)
	
	function frameAnchor:SetTip(frame)
		local x,y = frame:GetCenter()
		if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
		local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
		local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
		return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
	end

	frameAnchor:Hide() -- hide it by default
	
	addon:RestoreLayout(name)
end

function addon:CreateDebuffTimers()
	
    local Frm = CreateFrame("Frame", nil, UIParent)

    Frm:SetWidth(ICON_SIZE)
    Frm:SetHeight(ICON_SIZE)
	Frm:SetFrameStrata("LOW")
	Frm:SetScale(XDT_DB.scale)
	
    Frm.icon = Frm:CreateTexture(nil, "BACKGROUND")
    Frm.icon:SetTexCoord(.07, .93, .07, .93)
    Frm.icon:SetWidth(ICON_SIZE)
    Frm.icon:SetHeight(ICON_SIZE)
	Frm.icon:SetTexture("Interface\\Icons\\Spell_Shadow_Shadowbolt")
    Frm.icon:SetAllPoints(true)
    
    Frm.stacktext = Frm:CreateFontString(nil, "OVERLAY");
    Frm.stacktext:SetFont(STANDARD_TEXT_FONT,10,"OUTLINE")
    Frm.stacktext:SetWidth(Frm.icon:GetWidth())
    Frm.stacktext:SetHeight(Frm.icon:GetHeight())
    Frm.stacktext:SetJustifyH("RIGHT")
    Frm.stacktext:SetVertexColor(1,1,1)
    Frm.stacktext:SetPoint("RIGHT", Frm.icon, "RIGHT",1,-5)
    
    Frm.timetext = Frm:CreateFontString(nil, "OVERLAY");
    Frm.timetext:SetFont(STANDARD_TEXT_FONT,10,"OUTLINE")
    Frm.timetext:SetJustifyH("RIGHT")
    Frm.timetext:SetPoint("RIGHT", Frm.icon, "LEFT" , -5, 0)

	Frm.Bar = Frm:CreateFontString(nil, "GameFontNormal")
	Frm.Bar:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE, MONOCHROME")
	Frm.Bar:SetText(BAR_TEXT)
	Frm.Bar:SetPoint("LEFT", Frm.icon, "RIGHT", 1, 0)
	
	Frm:Hide()
    
	return Frm
	
end

function addon:generateBars()
	local adj = 0
	
	--lets create the max bars to use on screen for future sorting
	for i=1, addon.MAX_TIMERS do
		addon.timers[i] = addon:CreateDebuffTimers()
		if not addon.timers.debuffs[i] then addon.timers.debuffs[i] = {} end
		if isRetail then
			addon.timersFocus[i] = addon:CreateDebuffTimers()
			if not addon.timersFocus.debuffs[i] then addon.timersFocus.debuffs[i] = {} end
		end
	end
		
	--rearrange order
	for i=1, addon.MAX_TIMERS do
		if XDT_DB.grow then
			addon.timers[i]:ClearAllPoints()
			addon.timers[i]:SetPoint("TOPLEFT", XDT_Anchor, "BOTTOMRIGHT", 0, adj)
			if isRetail then
				addon.timersFocus[i]:ClearAllPoints()
				addon.timersFocus[i]:SetPoint("TOPLEFT", XDT_FocusAnchor, "BOTTOMRIGHT", 0, adj)
			end
		else
			addon.timers[i]:ClearAllPoints()
			addon.timers[i]:SetPoint("BOTTOMLEFT", XDT_Anchor, "TOPRIGHT", 0, (adj * -1))
			if isRetail then
				addon.timersFocus[i]:ClearAllPoints()
				addon.timersFocus[i]:SetPoint("BOTTOMLEFT", XDT_FocusAnchor, "TOPRIGHT", 0, (adj * -1))
			end
		end
		adj = adj - BAR_ADJUST
    end
	
	barsLoaded = true
end

function addon:adjustBars()
	if not barsLoaded then return end
	
	local adj = 0
	for i=1, addon.MAX_TIMERS do
		if XDT_DB.grow then
			addon.timers[i]:ClearAllPoints()
			addon.timers[i]:SetPoint("TOPLEFT", XDT_Anchor, "BOTTOMRIGHT", 0, adj)
			if isRetail then
				addon.timersFocus[i]:ClearAllPoints()
				addon.timersFocus[i]:SetPoint("TOPLEFT", XDT_FocusAnchor, "BOTTOMRIGHT", 0, adj)
			end
		else
			addon.timers[i]:ClearAllPoints()
			addon.timers[i]:SetPoint("BOTTOMLEFT", XDT_Anchor, "TOPRIGHT", 0, (adj * -1))
			if isRetail then
				addon.timersFocus[i]:ClearAllPoints()
				addon.timersFocus[i]:SetPoint("BOTTOMLEFT", XDT_FocusAnchor, "TOPRIGHT", 0, (adj * -1))
			end
		end
		adj = adj - BAR_ADJUST
    end
end

function addon:ProcessDebuffBar(data)
	if data.isInfinite then return end --dont do any calculations on infinite
	
	local beforeEnd = data.endTime - GetTime()
	-- local percentTotal = (beforeEnd / data.durationTime)
	-- local percentFinal = ceil(percentTotal * 100)
	-- local barLength = ceil( string.len(BAR_TEXT) * percentTotal )

	--calculate the individual bar segments and make the appropriate calculations
	local totalDuration = (data.endTime - data.startTime) --total duration of the spell
	local totalBarSegment = (string.len(BAR_TEXT) / totalDuration) --lets get how much each segment of the bar string would value up to 100%
	local totalBarLength = totalBarSegment * beforeEnd --now get the individual bar segment value and multiply it with current duration
	local barPercent = (totalBarLength / string.len(BAR_TEXT)) * 100
	
	--100/40 means each segment is 2.5 for 100%
	--example for 50%   50/100 = 0.5   0.5 / 2.5 = 0.2  (50% divided by segment count) 0.2 * 100 = 20 (which is half of the bar of 40)

	if barPercent <= 0 or beforeEnd <= 0 or totalBarLength <= 0 then
		data.active = false
		return               
	end
	
	data.percent = barPercent
	data.totalBarLength = totalBarLength
	data.beforeEnd = beforeEnd
	
end
	
----------------------
-- Debuff Functions --
----------------------

--lets use one global OnUpdate instead of individual ones for each debuff bar
addon:SetScript("OnUpdate", function(self, elapsed)
	self.OnUpdateCounter = (self.OnUpdateCounter or 0) + elapsed
	if self.OnUpdateCounter < 0.05 then return end
	self.OnUpdateCounter = 0

	local tCount = 0
	local fCount = 0
	
	if not barsLoaded then return end
	
	for i=1, addon.MAX_TIMERS do
		if addon.timers.debuffs[i].active then
			self:ProcessDebuffBar(addon.timers.debuffs[i])
			tCount = tCount + 1
		end
		if isRetail and addon.timersFocus.debuffs[i].active then
			self:ProcessDebuffBar(addon.timersFocus.debuffs[i])
			fCount = fCount + 1
		end
	end
	
	--no need to arrange the bars if there is nothing to work with, uncessary if no target or focus
	if tCount > 0 then
		addon:ShowDebuffs("target")
	end
	if isRetail and fCount > 0 then
		addon:ShowDebuffs("focus")
	end

	
end)

function addon:ProcessDebuffs(id)
	if not barsLoaded then return end
	
	local sdTimer = timerList[id] --makes things easier to read
	
	for i=1, addon.MAX_TIMERS do
		local name, icon, count, debuffType, duration, expTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId = UnitAura(id, i, 'PLAYER|HARMFUL')
		
		local passChk = false
		local isInfinite = false
		
		--only allow infinite debuffs if the user enabled it
		if XDT_DB.showInfinite then
			--auras are on so basically were allowing everything
			passChk = true
			if not duration or duration <= 0 or not expTime or expTime <= 0 then
				isInfinite = true
			end
		end
		if not XDT_DB.showInfinite and duration and duration > 0 then 
			--auras are not on but the duration is greater then zero, so allow
			passChk = true
		end
		
		--check for duration > 0 for the evil DIVIDE BY ZERO
		if name and passChk then
			local beforeEnd = 0
			local startTime = 0
			local totalDuration = 0
			local totalBarSegment = 0
			local totalBarLength = 0
			local barPercent = 0
		
			if isInfinite then
				barPercent = 200 --anything higher than 100 will get pushed to top of list, so lets make it 200 -> addon:ShowBuffs(id)
				duration = 0
				expTime = 0
				totalBarLength = string.len(BAR_TEXT) --just make it full bar length, it will never decrease anyways
			else
				beforeEnd = expTime - GetTime()
				startTime = (expTime - duration)
				totalDuration = (expTime - startTime) --total duration of the spell
				totalBarSegment = (string.len(BAR_TEXT) / totalDuration) --lets get how much each segment of the bar string would value up to 100%
				totalBarLength = totalBarSegment * beforeEnd --now get the individual bar segment value and multiply it with current duration
				barPercent = (totalBarLength / string.len(BAR_TEXT)) * 100
			end
		
			if barPercent > 0 or beforeEnd > 0 or totalBarLength > 0 then
				--debuffs
				sdTimer.debuffs[i].id = id
				sdTimer.debuffs[i].spellName = name
				sdTimer.debuffs[i].spellId = spellId
				sdTimer.debuffs[i].iconTex = icon
				sdTimer.debuffs[i].startTime = startTime
				sdTimer.debuffs[i].durationTime = duration
				sdTimer.debuffs[i].beforeEnd = beforeEnd
				sdTimer.debuffs[i].endTime = expTime
				sdTimer.debuffs[i].totalBarLength = totalBarLength
				sdTimer.debuffs[i].stacks = count or 0
				sdTimer.debuffs[i].percent = barPercent
				sdTimer.debuffs[i].active = true
				sdTimer.debuffs[i].isInfinite = isInfinite
			end
		else
			sdTimer.debuffs[i].active = false
		end
	end
	
	addon:ShowDebuffs(id)
end

function addon:ClearDebuffs(id)
	if not barsLoaded then return end
	
	local sdTimer = timerList[id] --makes things easier to read
	local adj = 0

	for i=1, addon.MAX_TIMERS do
		sdTimer.debuffs[i].active = false
		sdTimer[i]:Hide()
	end
	
end

function addon:ReloadDebuffs()
	addon:ClearDebuffs("target")
	addon:ProcessDebuffs("target")
	if isRetail then
		addon:ClearDebuffs("focus")
		addon:ProcessDebuffs("focus")
	end
end

function addon:ShowDebuffs(id)
	if not barsLoaded then return end
	
	if locked then return end
	locked = true
	
	local sdTimer
	local tmpList = {}

	if id == "target" then
		sdTimer = addon.timers
	elseif id == "focus" and isRetail then
		sdTimer = addon.timersFocus
	else
		locked = false
		return
	end
	
	for i=1, addon.MAX_TIMERS do
		if sdTimer.debuffs[i].active then
			table.insert(tmpList, sdTimer.debuffs[i])
		end
	end
	
	if XDT_DB.grow then
		--bars will grow down
		if XDT_DB.sort then
			--sort from shortest to longest
			table.sort(tmpList, function(a,b) return (a.percent < b.percent) end)
			
		else
			--sort from longest to shortest
			table.sort(tmpList, function(a,b) return (a.percent > b.percent) end)
			
		end
	else
		--bars will grow up
		if XDT_DB.sort then
			--sort from shortest to longest
			table.sort(tmpList, function(a,b) return (a.percent > b.percent) end)
			
		else
			--sort from longest to shortest
			table.sort(tmpList, function(a,b) return (a.percent < b.percent) end)
		end
	end
	
	for i=1, addon.MAX_TIMERS do
		if tmpList[i] then
			--display the information
			---------------------------------------
			sdTimer[i].Bar:SetText( string.sub(BAR_TEXT, 1, tmpList[i].totalBarLength) )
			sdTimer[i].icon:SetTexture(tmpList[i].iconTex)
			
			if tmpList[i].stacks > 0 then
				sdTimer[i].stacktext:SetText(tmpList[i].stacks)
			else
				sdTimer[i].stacktext:SetText(nil)
			end
			if tmpList[i].isInfinite then
				sdTimer[i].timetext:SetText("∞")
				sdTimer[i].Bar:SetTextColor(128/255,128/255,128/255)
			else
				sdTimer[i].timetext:SetText(addon:GetTimeText(ceil(tmpList[i].beforeEnd)))
				sdTimer[i].Bar:SetTextColor(addon:getBarColor(tmpList[i].durationTime, tmpList[i].beforeEnd))
			end
			---------------------------------------
			
			sdTimer[i]:Show()
		else
			sdTimer[i]:Hide()
		end
    end

	locked = false
end

----------------------
-- Local Functions  --
----------------------
	
	
function addon:SaveLayout(frame)
	if type(frame) ~= "string" then return end
	if not _G[frame] then return end
	if not XDT_DB then XDT_DB = {} end
	
	local opt = XDT_DB[frame] or nil

	if not opt then
		XDT_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["xOfs"] = 0,
			["yOfs"] = 0,
		}
		opt = XDT_DB[frame]
		return
	end

	local point, relativeTo, relativePoint, xOfs, yOfs = _G[frame]:GetPoint()
	opt.point = point
	opt.relativePoint = relativePoint
	opt.xOfs = xOfs
	opt.yOfs = yOfs
end

function addon:RestoreLayout(frame)
	if type(frame) ~= "string" then return end
	if not _G[frame] then return end
	if not XDT_DB then XDT_DB = {} end

	local opt = XDT_DB[frame] or nil

	if not opt then
		XDT_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["xOfs"] = 0,
			["yOfs"] = 0,
		}
		opt = XDT_DB[frame]
	end

	_G[frame]:ClearAllPoints()
	_G[frame]:SetPoint(opt.point, UIParent, opt.relativePoint, opt.xOfs, opt.yOfs)
end

function addon:getBarColor(dur, expR)
	local r
	local g = 1
	local cur = 2 * expR/dur
	if cur > 1 then
		return 2 - cur, 1, 0
	else
		return 1, cur, 0
	end
end

function addon:GetTimeText(timeLeft)
	local hours, minutes, seconds = 0, 0, 0
	if( timeLeft >= 3600 ) then
		hours = ceil(timeLeft / 3600)
		timeLeft = mod(timeLeft, 3600)
	end

	if( timeLeft >= 60 ) then
		minutes = ceil(timeLeft / 60)
		timeLeft = mod(timeLeft, 60)
	end

	seconds = timeLeft > 0 and timeLeft or 0

	if hours > 0 then
		return string.format("%d"..L.TimeHour, hours)
	elseif minutes > 0 then
		return string.format("%d"..L.TimeMinute, minutes)
	elseif seconds > 0 then
		return string.format("%d"..L.TimeSecond, seconds)
	else
		return nil
	end
end

if IsLoggedIn() then addon:PLAYER_LOGIN() else addon:RegisterEvent("PLAYER_LOGIN") end
