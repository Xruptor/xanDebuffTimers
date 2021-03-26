local ADDON_NAME, addon = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent, BackdropTemplateMixin and "BackdropTemplate")
end
addon = _G[ADDON_NAME]

addon.configFrame = CreateFrame("frame", ADDON_NAME.."_config_eventFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
local configFrame = addon.configFrame

local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)
local isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local lastObject

local function addConfigEntry(objEntry, adjustX, adjustY)
	
	objEntry:ClearAllPoints()
	
	if not lastObject then
		objEntry:SetPoint("TOPLEFT", 20, -150)
	else
		objEntry:SetPoint("LEFT", lastObject, "BOTTOMLEFT", adjustX or 0, adjustY or -30)
	end
	
	lastObject = objEntry
end

local chkBoxIndex = 0
local function createCheckbutton(parentFrame, displayText)
	chkBoxIndex = chkBoxIndex + 1
	
	local checkbutton = CreateFrame("CheckButton", ADDON_NAME.."_config_chkbtn_" .. chkBoxIndex, parentFrame, "ChatConfigCheckButtonTemplate")
	getglobal(checkbutton:GetName() .. 'Text'):SetText(" "..displayText)
	
	return checkbutton
end

local buttonIndex = 0
local function createButton(parentFrame, displayText)
	buttonIndex = buttonIndex + 1
	
	local button = CreateFrame("Button", ADDON_NAME.."_config_button_" .. buttonIndex, parentFrame, "UIPanelButtonTemplate")
	button:SetText(displayText)
	button:SetHeight(30)
	button:SetWidth(button:GetTextWidth() + 30)

	return button
end

local sliderIndex = 0
local function createSlider(parentFrame, displayText, minVal, maxVal)
	sliderIndex = sliderIndex + 1
	
	local SliderBackdrop  = {
		bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
		edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 3, right = 3, top = 6, bottom = 6 }
	}
	
	local slider = CreateFrame("Slider", ADDON_NAME.."_config_slider_" .. sliderIndex, parentFrame, BackdropTemplateMixin and "BackdropTemplate")
	slider:SetOrientation("HORIZONTAL")
	slider:SetHeight(15)
	slider:SetWidth(300)
	slider:SetHitRectInsets(0, 0, -10, 0)
	slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
	slider:SetMinMaxValues(minVal or 0, maxVal or 100)
	slider:SetValue(0)
	slider:SetBackdrop(SliderBackdrop)

	local label = slider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetPoint("CENTER", slider, "CENTER", 0, 16)
	label:SetJustifyH("CENTER")
	label:SetHeight(15)
	label:SetText(displayText)

	local lowtext = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	lowtext:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 2, 3)
	lowtext:SetText(minVal)

	local hightext = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	hightext:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", -2, 3)
	hightext:SetText(maxVal)
	
	local currVal = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	currVal:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 45, 12)
	currVal:SetText('(?)')
	slider.currVal = currVal
	
	return slider
end

local function LoadAboutFrame()

	--Code inspired from tekKonfigAboutPanel
	local about = CreateFrame("Frame", ADDON_NAME.."AboutPanel", InterfaceOptionsFramePanelContainer, BackdropTemplateMixin and "BackdropTemplate")
	about.name = ADDON_NAME
	about:Hide()
	
    local fields = {"Version", "Author"}
	local notes = GetAddOnMetadata(ADDON_NAME, "Notes")

    local title = about:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")

	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(ADDON_NAME)

	local subtitle = about:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetHeight(32)
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetPoint("RIGHT", about, -32, 0)
	subtitle:SetNonSpaceWrap(true)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText(notes)

	local anchor
	for _,field in pairs(fields) do
		local val = GetAddOnMetadata(ADDON_NAME, field)
		if val then
			local title = about:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			title:SetWidth(75)
			if not anchor then title:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -2, -8)
			else title:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6) end
			title:SetJustifyH("RIGHT")
			title:SetText(field:gsub("X%-", ""))

			local detail = about:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			detail:SetPoint("LEFT", title, "RIGHT", 4, 0)
			detail:SetPoint("RIGHT", -16, 0)
			detail:SetJustifyH("LEFT")
			detail:SetText(val)

			anchor = title
		end
	end
	
	InterfaceOptions_AddCategory(about)

	return about
end

function configFrame:EnableConfig()
	
	addon.aboutPanel = LoadAboutFrame()
	
	--anchor
	local btnAnchor = createButton(addon.aboutPanel, L.SlashAnchorText)
	btnAnchor.func = function()
		if XDT_Anchor:IsVisible() then
			XDT_Anchor:Hide()
			if isRetail then
				XDT_FocusAnchor:Hide()
			end
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashAnchorOff)
		else
			XDT_Anchor:Show()
			if isRetail then
				XDT_FocusAnchor:Show()
			end
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashAnchorOn)
		end
	end
	btnAnchor:SetScript("OnClick", btnAnchor.func)
	
	addConfigEntry(btnAnchor, 0, -30)
	addon.aboutPanel.btnAnchor = btnAnchor
	
	--reset
	local btnReset = createButton(addon.aboutPanel, L.SlashResetText)
	btnReset.func = function()
		DEFAULT_CHAT_FRAME:AddMessage(L.SlashResetAlert)
		XDT_Anchor:ClearAllPoints()
		XDT_Anchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		if isRetail then
			XDT_FocusAnchor:ClearAllPoints()
			XDT_FocusAnchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		end
	end
	btnReset:SetScript("OnClick", btnReset.func)
	
	addConfigEntry(btnReset, 0, -30)
	addon.aboutPanel.btnReset = btnReset
	
	--scale
	local sliderScale = createSlider(addon.aboutPanel, L.SlashScaleText, 0.1, 200)
	sliderScale:SetScript("OnShow", function()
		sliderScale:SetValue(floor(XDT_DB.scale * 100))
		sliderScale.currVal:SetText("("..floor(XDT_DB.scale * 100)..")")
	end)
	sliderScale.func = function(value)
		XDT_DB.scale = tonumber(value) / 100
		sliderScale:SetValue(floor(XDT_DB.scale * 100))
		sliderScale.currVal:SetText("("..floor(XDT_DB.scale * 100)..")")
		DEFAULT_CHAT_FRAME:AddMessage(string.format(L.SlashScaleSet, floor(value)))
		for i=1, addon.MAX_TIMERS do
			if addon.timers[i] then
				addon.timers[i]:SetScale(XDT_DB.scale)
			end
			if isRetail and addon.timersFocus[i] then
				addon.timersFocus[i]:SetScale(XDT_DB.scale)
			end
		end
	end
	sliderScale.sliderMouseUp = function(self, button)
		sliderScale.func(sliderScale:GetValue())
	end
	sliderScale.sliderFunc = function(self, value)
		sliderScale.currVal:SetText("("..floor(value)..")")
		for i=1, addon.MAX_TIMERS do
			if addon.timers[i] then
				addon.timers[i]:SetScale(tonumber(value) / 100)
			end
			if isRetail and addon.timersFocus[i] then
				addon.timersFocus[i]:SetScale(tonumber(value) / 100)
			end
		end
	end
	sliderScale:SetScript("OnValueChanged", sliderScale.sliderFunc)
	sliderScale:SetScript("OnMouseUp", sliderScale.sliderMouseUp)
	
	addConfigEntry(sliderScale, 0, -40)
	addon.aboutPanel.sliderScale = sliderScale
	
	--infinite
	local btnInfinite = createCheckbutton(addon.aboutPanel, L.SlashInfiniteChkBtn)
	btnInfinite:SetScript("OnShow", function() btnInfinite:SetChecked(XDT_DB.showInfinite) end)
	btnInfinite.func = function(slashSwitch)
		local value = XDT_DB.showInfinite
		if not slashSwitch then value = XDT_DB.showInfinite end

		if value then
			XDT_DB.showInfinite = false
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashInfiniteOff)
		else
			XDT_DB.showInfinite = true
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashInfiniteOn)
		end
		
		addon:ReloadDebuffs()
	end
	btnInfinite:SetScript("OnClick", btnInfinite.func)
	
	addConfigEntry(btnInfinite, 0, -40)
	addon.aboutPanel.btnInfinite = btnInfinite
	
	--grow
	local btnGrow = createCheckbutton(addon.aboutPanel, L.SlashGrowChkBtn)
	btnGrow:SetScript("OnShow", function() btnGrow:SetChecked(XDT_DB.grow) end)
	btnGrow.func = function(slashSwitch)
		local value = XDT_DB.grow
		if not slashSwitch then value = XDT_DB.grow end

		if value then
			XDT_DB.grow = false
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashGrowUp)
		else
			XDT_DB.grow = true
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashGrowDown)
		end
		
		addon:adjustBars()
	end
	btnGrow:SetScript("OnClick", btnGrow.func)
	
	addConfigEntry(btnGrow, 0, -20)
	addon.aboutPanel.btnGrow = btnGrow
	
	--sort
	local btnSort = createCheckbutton(addon.aboutPanel, L.SlashSortChkBtn)
	btnSort:SetScript("OnShow", function() btnSort:SetChecked(XDT_DB.sort) end)
	btnSort.func = function(slashSwitch)
		local value = XDT_DB.sort
		if not slashSwitch then value = XDT_DB.sort end

		if value then
			XDT_DB.sort = false
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashSortDescending)
		else
			XDT_DB.sort = true
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashSortAscending)
		end
		
		addon:adjustBars()
	end
	btnSort:SetScript("OnClick", btnSort.func)
	
	addConfigEntry(btnSort, 0, -20)
	addon.aboutPanel.btnSort = btnSort
	
	--reload debuffs
	local btnReloadDebuffs = createButton(addon.aboutPanel, L.SlashReloadText)
	btnReloadDebuffs.func = function()
		addon:ReloadDebuffs()
		DEFAULT_CHAT_FRAME:AddMessage(L.SlashReloadAlert)
	end
	btnReloadDebuffs:SetScript("OnClick", btnReloadDebuffs.func)
	
	addConfigEntry(btnReloadDebuffs, 0, -30)
	addon.aboutPanel.btnReloadDebuffs = btnReloadDebuffs
end
