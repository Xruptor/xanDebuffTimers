
local ADDON_NAME, private = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent, BackdropTemplateMixin and "BackdropTemplate")
end
local addon = _G[ADDON_NAME]
addon.private = private
addon.L = (private and private.L) or addon.L or {}

addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" or event == "PLAYER_LOGIN" then
		if event == "ADDON_LOADED" then
			local arg1 = ...
			if arg1 and arg1 == ADDON_NAME then
				self:UnregisterEvent("ADDON_LOADED")
				self:RegisterEvent("PLAYER_LOGIN")
			end
			return
		end
		if IsLoggedIn() then
			self:EnableAddon(event, ...)
			self:UnregisterEvent("PLAYER_LOGIN")
		end
		return
	end
	if self[event] then
		return self[event](self, event, ...)
	end
end)

local L = addon.L
local canFocusT = (FocusUnit and FocusFrame) or false

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
local BAR_TEXT_LEN = #BAR_TEXT
local locked = false
local TIMER_TEXT_PADDING = 8

local WOW_PROJECT_ID = _G.WOW_PROJECT_ID
local WOW_PROJECT_MAINLINE = _G.WOW_PROJECT_MAINLINE
local WOW_PROJECT_CLASSIC = _G.WOW_PROJECT_CLASSIC
local isClassic = (WOW_PROJECT_ID and WOW_PROJECT_CLASSIC and WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) or false
local isRetail = (WOW_PROJECT_ID and WOW_PROJECT_MAINLINE and WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) or false

local LibClassicDurations = nil
if isClassic and LibStub then
	LibClassicDurations = LibStub("LibClassicDurations", true)
	if LibClassicDurations and LibClassicDurations.Register then
		LibClassicDurations:Register(ADDON_NAME)
	end
end

local GetAuraDataByIndex = C_UnitAuras and C_UnitAuras.GetAuraDataByIndex
local AURA_FILTER = "PLAYER|HARMFUL"

local function HasValidTimes(duration, expirationTime)
	return type(duration) == "number" and duration > 0
		and type(expirationTime) == "number" and expirationTime > 0
end

local function BuildAuraFromUnitAura(unit, index, filter, unitAuraFunc)
	local name, icon, count, debuffType, duration, expirationTime, sourceUnit, isStealable,
		nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll,
		timeMod, value1, value2, value3 = unitAuraFunc(unit, index, filter)

	if not name then return nil end

	return {
		name = name,
		icon = icon,
		applications = count,
		duration = duration,
		expirationTime = expirationTime,
		sourceUnit = sourceUnit,
		spellId = spellId,
		isHarmful = true,
	}
end

local function GetAuraData(unit, index, filter)
	if GetAuraDataByIndex then
		local auraData = GetAuraDataByIndex(unit, index, filter)
		if auraData and isClassic and LibClassicDurations and LibClassicDurations.UnitAuraWrapper
			and not HasValidTimes(auraData.duration, auraData.expirationTime) then
			local lcdAura = BuildAuraFromUnitAura(unit, index, filter, LibClassicDurations.UnitAuraWrapper)
			if lcdAura and HasValidTimes(lcdAura.duration, lcdAura.expirationTime) then
				return lcdAura
			end
		end
		return auraData
	end

	-- Classic/legacy API fallback
	local auraData = BuildAuraFromUnitAura(unit, index, filter, UnitAura)
	if auraData and isClassic and LibClassicDurations and LibClassicDurations.UnitAuraWrapper
		and not HasValidTimes(auraData.duration, auraData.expirationTime) then
		local lcdAura = BuildAuraFromUnitAura(unit, index, filter, LibClassicDurations.UnitAuraWrapper)
		if lcdAura then
			return lcdAura
		end
	end
	return auraData
end

local timerList = {
	target = addon.timers,
	focus = addon.timersFocus,
}

local barsLoaded = false

----------------------
--      Enable      --
----------------------

function addon:EnableAddon()

	if not XDT_DB then XDT_DB = {} end
	if XDT_DB.scale == nil then XDT_DB.scale = 1 end
	if XDT_DB.grow == nil then XDT_DB.grow = false end
	if XDT_DB.sort == nil then XDT_DB.sort = false end
	if XDT_DB.showInfinite == nil then XDT_DB.showInfinite = true end
	if XDT_DB.showIcon == nil then XDT_DB.showIcon = true end
	if XDT_DB.showSpellName == nil then XDT_DB.showSpellName = false end
	if XDT_DB.hideInRestedAreas == nil then XDT_DB.hideInRestedAreas = false end
	if XDT_DB.showTimerOnRight == nil then XDT_DB.showTimerOnRight = true end
	if XDT_DB.useGraphicBar == nil then XDT_DB.useGraphicBar = false end
	if XDT_DB.barColor == nil then XDT_DB.barColor = { r = 0.75, g = 0, b = 0 } end
	if XDT_DB.showRetailWarning == nil then XDT_DB.showRetailWarning = true end
	if XDT_DB.retailWarningCount == nil then XDT_DB.retailWarningCount = 0 end

	--create our anchors
	addon:CreateAnchor("XDT_Anchor", UIParent, L.BarTargetAnchor)
	if canFocusT then
		addon:CreateAnchor("XDT_FocusAnchor", UIParent, L.BarFocusAnchor)
	end

	--create our bars
	addon:generateBars()

	if isRetail then
		XDT_DB.retailWarningCount = (XDT_DB.retailWarningCount or 0) + 1
		addon:ShowRetailWarning()
	end

	addon:RegisterEvent("UNIT_AURA")
	addon:RegisterEvent("PLAYER_TARGET_CHANGED")

	if canFocusT then
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
					if scalenum and scalenum ~= "" and tonumber(scalenum) and tonumber(scalenum) >= 0.5 and tonumber(scalenum) <= 5 then
						addon:SetAddonScale(tonumber(scalenum))
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

	if addon.configFrame then addon.configFrame:EnableConfig() end

	local ver = C_AddOns.GetAddOnMetadata(ADDON_NAME,"Version") or '1.0'
	DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF99CC33%s|r [v|cFF20ff20%s|r] loaded:   /xdt", ADDON_NAME, ver or "1.0"))
end

function addon:PLAYER_TARGET_CHANGED()
	addon:ProcessDebuffs("target")
end

function addon:PLAYER_FOCUS_CHANGED()
	if not canFocusT then return end
	addon:ProcessDebuffs("focus")
end

function addon:ShowRetailWarning()
	if not isRetail then return end
	if not XDT_DB or XDT_DB.showRetailWarning == false then return end
	local count = XDT_DB.retailWarningCount or 0
	if not (count == 1 or (count % 3 == 0)) then return end

	local frame = CreateFrame("Frame", "XDT_RetailWarningFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	frame:SetSize(520, 420)
	frame:SetPoint("CENTER", UIParent, "CENTER", -260, 0)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	frame:SetBackdropColor(0, 0, 0, 0.85)

	frame.addonTitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	frame.addonTitle:SetPoint("TOP", frame, "TOP", 0, -12)
	frame.addonTitle:SetTextColor(0.2, 1, 0.2)
	frame.addonTitle:SetText(ADDON_NAME)

	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	frame.title:SetPoint("TOP", frame.addonTitle, "BOTTOM", 0, -18)
	frame.title:SetTextColor(1, 0.2, 0.2)
	frame.title:SetText(L.RetailWarningTitle or "WARNING PLEASE READ!!!  RETAIL ONLY")

	local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -92)
	scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -36, 52)

	local content = CreateFrame("Frame", nil, scrollFrame)
	content:SetSize(1, 1)
	scrollFrame:SetScrollChild(content)

	frame.body = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	frame.body:SetJustifyH("LEFT")
	frame.body:SetJustifyV("TOP")
	frame.body:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
	frame.body:SetWidth(440)
	frame.body:SetText(L.RetailWarningBody or "")

	local height = frame.body:GetStringHeight()
	if height and height > 0 then
		content:SetHeight(height + 10)
	end

	frame.okBTN = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.okBTN:SetText(OKAY)
	frame.okBTN:SetSize(100, 30)
	frame.okBTN:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 16)
	frame.okBTN:SetScript("OnClick", function()
		frame:Hide()
	end)

	frame:Show()
end

addon.auraList = {
	target = {},
	focus = {},
}
local allowedList = {
	player = true,
	pet = true,
	vehicle = true,
}
local issecretvalue = _G.issecretvalue
local canaccessvalue = _G.canaccessvalue

local function CanAccessValue(value)
	if issecretvalue and issecretvalue(value) then
		return canaccessvalue and canaccessvalue(value)
	end
	return true
end

local function SafeTrue(value)
	if not CanAccessValue(value) then
		return false
	end
	return value == true
end

local function SafeValue(value)
	if not CanAccessValue(value) then
		return nil
	end
	return value
end
local function TruncateText(fontString, text, maxWidth)
	if not text or text == "" then return "" end
	if not maxWidth or maxWidth <= 0 then return "" end
	fontString:SetText(text)
	if fontString:GetStringWidth() <= maxWidth then
		return text
	end
	local suffix = "..."
	local left = 1
	local right = #text
	local best = ""
	while left <= right do
		local mid = math.floor((left + right) / 2)
		local candidate = string.sub(text, 1, mid) .. suffix
		fontString:SetText(candidate)
		if fontString:GetStringWidth() <= maxWidth then
			best = candidate
			left = mid + 1
		else
			right = mid - 1
		end
	end
	return best
end

local function checkPlayerCasted(auraInfo, unitID)
	local isPlayer = false
	local isFullUpdate = not auraInfo or auraInfo.isFullUpdate

	if isFullUpdate then
		--force a full scan anyways
		isPlayer = true
	else
		if auraInfo then
			if auraInfo.addedAuras then
				for _, data in next, auraInfo.addedAuras do
					--only process Harmful spells that we cast
					local sourceUnit = SafeValue(data.sourceUnit)
					if SafeTrue(data.isHarmful) and sourceUnit and allowedList[sourceUnit] then
						isPlayer = true
					end
				end
			end

			if auraInfo.updatedAuraInstanceIDs then
				for _, auraInstanceID in next, auraInfo.updatedAuraInstanceIDs do
					if addon.auraList[unitID][auraInstanceID] then
						isPlayer = true
					end
				end
			end

			if auraInfo.removedAuraInstanceIDs then
				for _, auraInstanceID in next, auraInfo.removedAuraInstanceIDs do
					if addon.auraList[unitID][auraInstanceID] then
						isPlayer = true
					end
				end
			end
		end
	end

	return isPlayer
end

function addon:UNIT_AURA(event, unit, info)
	if canFocusT and unit == "focus" then
		addon:ProcessDebuffs("focus")
	elseif unit == "target" then
		addon:ProcessDebuffs("target")
	end
end

----------------------
--  Frame Creation  --
----------------------

function addon:CreateAnchor(name, parent, desc)

	--create the anchor
	local frameAnchor = CreateFrame("Frame", name, parent, BackdropTemplateMixin and "BackdropTemplate")

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

    local Frm = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")

    Frm:SetWidth(ICON_SIZE)
    Frm:SetHeight(ICON_SIZE)
	Frm:SetFrameStrata("LOW")
	Frm:SetFrameLevel(2)

	addon:SetAddonScale(XDT_DB.scale, true)

    Frm.icon = Frm:CreateTexture(nil, "BACKGROUND")
    Frm.icon:SetTexCoord(.07, .93, .07, .93)
    Frm.icon:SetWidth(ICON_SIZE)
    Frm.icon:SetHeight(ICON_SIZE)
	Frm.icon:SetTexture("Interface\\Icons\\Spell_Shadow_Shadowbolt")
    Frm.icon:SetAllPoints(Frm)

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
    Frm.timetext:SetPoint("LEFT", Frm.icon, "RIGHT", 5, 0)

    Frm.spellNameText = Frm:CreateFontString(nil, "OVERLAY");
    Frm.spellNameText:SetFont(STANDARD_TEXT_FONT,10,"OUTLINE")
	Frm.spellNameText:SetTextColor(1,1,1)
    Frm.spellNameText:SetJustifyH("RIGHT")
    Frm.spellNameText:SetPoint("RIGHT", Frm.icon, "LEFT" , -5, 0)
	Frm.spellNameText:SetWordWrap(false)
	Frm.spellNameText:SetNonSpaceWrap(true)

	Frm.Bar = Frm:CreateFontString(nil, "OVERLAY")
	Frm.Bar:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
	Frm.Bar:SetText(BAR_TEXT)
	Frm.Bar:SetPoint("LEFT", Frm.icon, "RIGHT", 33, 0)

	Frm.graphBar = CreateFrame("StatusBar", nil, Frm)
	Frm.graphBar:SetStatusBarTexture("Interface\\AddOns\\xanDebuffTimers\\media\\HalT")
	Frm.graphBar:SetMinMaxValues(0, 1)
	Frm.graphBar:SetValue(1)
	Frm.graphBar:SetHeight(ICON_SIZE - 2)
	Frm.graphBar:SetFrameLevel(math.max(1, Frm:GetFrameLevel() - 1))
	do
		local barWidth = Frm.Bar:GetStringWidth()
		if not barWidth or barWidth <= 0 then barWidth = 120 end
		Frm.graphBar:SetWidth(barWidth + 8)
	end
	Frm.graphBar.bg = Frm.graphBar:CreateTexture(nil, "BACKGROUND")
	Frm.graphBar.bg:SetAllPoints(Frm.graphBar)
	Frm.graphBar.bg:SetColorTexture(0, 0, 0, 0.5)
	Frm.graphBar:Hide()

	Frm:Hide()

	return Frm

end

function addon:SetAddonScale(value, bypass)
	--fix this in case it's ever smaller than   
	if value < 0.5 then value = 0.5 end --anything smaller and it would vanish  
	if value > 5 then value = 5 end --WAY too big  

	XDT_DB.scale = value

	if not bypass then
		DEFAULT_CHAT_FRAME:AddMessage(string.format(L.SlashScaleSet, value))
	end

	for i=1, addon.MAX_TIMERS do
		if addon.timers[i] then
			addon.timers[i]:SetScale(XDT_DB.scale)
		end
		if canFocusT and addon.timersFocus[i] then
			addon.timersFocus[i]:SetScale(XDT_DB.scale)
		end
	end

end

function addon:adjustTextAlignment(sdTimer)
	if not sdTimer then return end

	--if we have the icon visible, we need to determine if we show the timer text on the left or right
	sdTimer.timetext:ClearAllPoints()
	sdTimer.Bar:ClearAllPoints()
	sdTimer.spellNameText:ClearAllPoints()
	if sdTimer.graphBar then
		sdTimer.graphBar:ClearAllPoints()
	end

	if XDT_DB.useGraphicBar and sdTimer.graphBar then
		sdTimer.Bar:Hide()
		sdTimer.graphBar:Show()
		sdTimer.spellNameText:SetJustifyH("LEFT")
		if XDT_DB.showIcon then
			sdTimer.graphBar:SetPoint("LEFT", sdTimer.icon, "RIGHT", 5, 0)
		else
			sdTimer.graphBar:SetPoint("LEFT", sdTimer, "LEFT", 0, 0)
		end
		sdTimer.spellNameText:SetPoint("LEFT", sdTimer.graphBar, "LEFT", 4, 0)
		sdTimer.timetext:SetPoint("RIGHT", sdTimer.graphBar, "RIGHT", -4, 0)
		return
	elseif sdTimer.graphBar then
		sdTimer.graphBar:Hide()
		sdTimer.Bar:Show()
		sdTimer.spellNameText:SetJustifyH("RIGHT")
	end

	if XDT_DB.showIcon then
		if XDT_DB.showTimerOnRight then
			sdTimer.timetext:SetPoint("LEFT", sdTimer.icon, "RIGHT", 5, 0)
			sdTimer.Bar:SetPoint("LEFT", sdTimer.icon, "RIGHT", 33, 0)
			sdTimer.spellNameText:SetPoint("RIGHT", sdTimer.icon, "LEFT" , -5, 0)
		else
			sdTimer.timetext:SetPoint("RIGHT", sdTimer.icon, "LEFT" , -5, 0)
			sdTimer.Bar:SetPoint("LEFT", sdTimer.icon, "RIGHT", 5, 0)
			sdTimer.spellNameText:SetPoint("RIGHT", sdTimer.timetext, "LEFT" , -5, 0)
		end
	else
		sdTimer.timetext:SetPoint("LEFT", sdTimer.icon, "RIGHT", 5, 0)
		sdTimer.Bar:SetPoint("LEFT", sdTimer.icon, "RIGHT", 33, 0)
		sdTimer.spellNameText:SetPoint("RIGHT", sdTimer.timetext, "LEFT" , -5, 0)
	end
end

function addon:generateBars()
	local adj = 0

	--lets create the max bars to use on screen for future sorting
	for i=1, addon.MAX_TIMERS do
		addon.timers[i] = addon:CreateDebuffTimers()
		if not addon.timers.debuffs[i] then addon.timers.debuffs[i] = {} end
		if canFocusT then
			addon.timersFocus[i] = addon:CreateDebuffTimers()
			if not addon.timersFocus.debuffs[i] then addon.timersFocus.debuffs[i] = {} end
		end
	end
	barsLoaded = true

	addon:adjustBars()
end

function addon:adjustBars()
	if not barsLoaded then return end

	local adj = 0
	for i=1, addon.MAX_TIMERS do

		--fix the text alignment based on our settings
		addon:adjustTextAlignment(addon.timers[i])
		if canFocusT then
			addon:adjustTextAlignment(addon.timersFocus[i])
		end

		if XDT_DB.grow then
			addon.timers[i]:ClearAllPoints()
			addon.timers[i]:SetPoint("TOPLEFT", XDT_Anchor, "BOTTOMRIGHT", 0, adj)
			if canFocusT then
				addon.timersFocus[i]:ClearAllPoints()
				addon.timersFocus[i]:SetPoint("TOPLEFT", XDT_FocusAnchor, "BOTTOMRIGHT", 0, adj)
			end
		else
			addon.timers[i]:ClearAllPoints()
			addon.timers[i]:SetPoint("BOTTOMLEFT", XDT_Anchor, "TOPRIGHT", 0, (adj * -1))
			if canFocusT then
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
	-- local percentFinal = floor(percentTotal * 100)
	-- local barLength = floor( string.len(BAR_TEXT) * percentTotal )

	--calculate the individual bar segments and make the appropriate calculations
	local totalDuration = (data.endTime - data.startTime) --total duration of the spell
	local totalBarSegment = (BAR_TEXT_LEN / totalDuration) --lets get how much each segment of the bar string would value up to 100%
	local totalBarLength = totalBarSegment * beforeEnd --now get the individual bar segment value and multiply it with current duration
	local barPercent = (totalBarLength / BAR_TEXT_LEN) * 100

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
		if canFocusT and addon.timersFocus.debuffs[i].active then
			self:ProcessDebuffBar(addon.timersFocus.debuffs[i])
			fCount = fCount + 1
		end
	end

	--no need to arrange the bars if there is nothing to work with, uncessary if no target or focus
	if tCount > 0 then
		addon:ShowDebuffs("target")
	end
	if canFocusT and fCount > 0 then
		addon:ShowDebuffs("focus")
	end

end)

function addon:ProcessDebuffs(id)
	if not barsLoaded then return end

	local sdTimer = timerList[id] --makes things easier to read

	if UnitIsDeadOrGhost(id) then
		addon:ClearDebuffs(id)
		return
	end

	--reset our list so it's clean, otherwise we may have carry overs from target swaps and this list can get big
	addon.auraList[id] = table.wipe(addon.auraList[id] or {})

	for i=1, addon.MAX_TIMERS do
		local passChk = false
		local isInfinite = false
		local auraData = GetAuraData(id, i, AURA_FILTER)

		--turn off by default, activate only if we have something
		sdTimer.debuffs[i].active = false

		if auraData then
			local auraKey = auraData.auraInstanceID or i
			addon.auraList[id][auraKey] = id

			--only allow infinite debuffs if the user enabled it
			if XDT_DB.showInfinite then
				passChk = true
				if not auraData.duration or auraData.duration <= 0 or not auraData.expirationTime or auraData.expirationTime <= 0 then
					isInfinite = true
				end
			end
			if not XDT_DB.showInfinite and auraData.duration and auraData.duration > 0 then
				passChk = true
			end

			--check for auraData.duration > 0 for the evil DIVIDE BY ZERO
			if auraData.name and passChk then
				local beforeEnd = 0
				local startTime = 0
				local totalDuration = 0
				local totalBarSegment = 0
				local totalBarLength = 0
				local barPercent = 0

				if isInfinite then
					barPercent = 200
					auraData.duration = 0
					auraData.expirationTime = 0
					totalBarLength = BAR_TEXT_LEN
				else
					beforeEnd = auraData.expirationTime - GetTime()
					startTime = (auraData.expirationTime - auraData.duration)
					totalDuration = (auraData.expirationTime - startTime)
					totalBarSegment = (BAR_TEXT_LEN / totalDuration)
					totalBarLength = totalBarSegment * beforeEnd
					barPercent = (totalBarLength / BAR_TEXT_LEN) * 100
				end

				if barPercent > 0 or beforeEnd > 0 or totalBarLength > 0 then
					sdTimer.debuffs[i].id = id
					sdTimer.debuffs[i].spellName = auraData.name
					sdTimer.debuffs[i].spellId = auraData.spellId
					sdTimer.debuffs[i].iconTex = auraData.icon
					sdTimer.debuffs[i].startTime = startTime
					sdTimer.debuffs[i].durationTime = auraData.duration
					sdTimer.debuffs[i].beforeEnd = beforeEnd
					sdTimer.debuffs[i].endTime = auraData.expirationTime
					sdTimer.debuffs[i].totalBarLength = totalBarLength
					sdTimer.debuffs[i].stacks = auraData.applications or 0
					sdTimer.debuffs[i].percent = barPercent
					sdTimer.debuffs[i].active = true
					sdTimer.debuffs[i].isInfinite = isInfinite
				end
			end
		end
	end

	addon:ShowDebuffs(id)
end

function addon:ClearDebuffs(id)
	if not barsLoaded then return end

	local sdTimer = timerList[id] --makes things easier to read
	local adj = 0

	addon.auraList[id] = table.wipe(addon.auraList[id] or {})

	for i=1, addon.MAX_TIMERS do
		sdTimer.debuffs[i].active = false
		sdTimer[i]:Hide()
	end

end

function addon:ReloadDebuffs()
	addon:ClearDebuffs("target")
	if canFocusT then
		addon:ClearDebuffs("focus")
	end

	addon:ProcessDebuffs("target")
	if canFocusT then
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
	elseif id == "focus" and canFocusT then
		sdTimer = addon.timersFocus
	else
		locked = false
		return
	end

	if UnitIsDeadOrGhost(id) then
		addon:ClearDebuffs(id)
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

	--don't show if we have this option enabled and we are resting
	local isRested = XDT_DB.hideInRestedAreas and IsResting()

	for i=1, addon.MAX_TIMERS do
		if tmpList[i] and not isRested then
			--display the information
			---------------------------------------
			if XDT_DB.useGraphicBar and sdTimer[i].graphBar then
				local dur = tmpList[i].durationTime
				local val = tmpList[i].beforeEnd
				if tmpList[i].isInfinite then
					dur = 1
					val = 1
					sdTimer[i].graphBar:SetStatusBarColor(0.5, 0.5, 0.5)
				else
					if not dur or dur <= 0 then dur = 1 end
					if not val or val < 0 then val = 0 end
					local clr = XDT_DB.barColor
					if clr then
						sdTimer[i].graphBar:SetStatusBarColor(clr.r or 1, clr.g or 0, clr.b or 0)
					else
						sdTimer[i].graphBar:SetStatusBarColor(addon:getBarColor(dur, val))
					end
				end
				sdTimer[i].graphBar:SetMinMaxValues(0, dur)
				sdTimer[i].graphBar:SetValue(val)
			else
				sdTimer[i].Bar:SetText( string.sub(BAR_TEXT, 1, tmpList[i].totalBarLength) )
			end

			if tmpList[i].isInfinite then
				sdTimer[i].timetext:SetText("∞")
				if not XDT_DB.useGraphicBar then
					sdTimer[i].Bar:SetTextColor(128/255,128/255,128/255)
				end
			else
				sdTimer[i].timetext:SetText(addon:GetTimeText(floor(tmpList[i].beforeEnd)))
				if not XDT_DB.useGraphicBar then
					sdTimer[i].Bar:SetTextColor(addon:getBarColor(tmpList[i].durationTime, tmpList[i].beforeEnd))
				end
			end

			if XDT_DB.showIcon then
				sdTimer[i].icon:SetTexture(tmpList[i].iconTex)
				if tmpList[i].stacks > 0 then
					sdTimer[i].stacktext:SetText(tmpList[i].stacks)
				else
					sdTimer[i].stacktext:SetText(nil)
				end
			else
				sdTimer[i].icon:SetTexture(nil)
				sdTimer[i].stacktext:SetText(nil)
			end
			if XDT_DB.showSpellName then
				local spellText = tmpList[i].spellName or ""
				if tmpList[i].stacks > 0 then
					spellText = "["..tmpList[i].stacks.."] "..spellText
				end
				local barWidth = 0
				if XDT_DB.useGraphicBar and sdTimer[i].graphBar and sdTimer[i].graphBar:IsShown() then
					barWidth = sdTimer[i].graphBar:GetWidth() or 0
				else
					barWidth = sdTimer[i].Bar:GetStringWidth() or 0
				end
				if barWidth <= 0 then barWidth = 120 end
				local timerWidth = sdTimer[i].timetext:GetStringWidth() or 0
				local maxWidth = barWidth - timerWidth - TIMER_TEXT_PADDING
				sdTimer[i].spellNameText:SetWidth(math.max(10, maxWidth))
				local finalText = TruncateText(sdTimer[i].spellNameText, spellText, maxWidth)
				sdTimer[i].spellNameText:SetText(finalText)
			else
				sdTimer[i].spellNameText:SetText("")
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
	if timeLeft <= 0 then return string.format("%d"..L.TimeSecond, 0) end

	local hours, minutes, seconds = 0, 0, 0
	if( timeLeft >= 3600 ) then
		hours = floor(timeLeft / 3600)
		timeLeft = mod(timeLeft, 3600)
	end

	if( timeLeft >= 60 ) then
		minutes = floor(timeLeft / 60)
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
		return string.format("%d"..L.TimeSecond, 0)
	end
end
