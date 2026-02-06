local ADDON_NAME, private = ...
if not _G[ADDON_NAME] then
	_G[ADDON_NAME] = CreateFrame("Frame", ADDON_NAME, UIParent, BackdropTemplateMixin and "BackdropTemplate")
end
local addon = _G[ADDON_NAME]

addon.configFrame = CreateFrame("frame", ADDON_NAME.."_config_eventFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
local configFrame = addon.configFrame

addon.private = private
addon.L = (private and private.L) or addon.L or {}
local L = addon.L
local canFocusT = (FocusUnit and FocusFrame) or false
local layout = {
	parent = nil,
	column = nil,
}

local function initLayout(parent)
	layout.parent = parent
	layout.column = { x = 18, y = -10, last = nil }
end

local function addConfigEntry(objEntry, adjustY)
	local col = layout.column
	if not col or not layout.parent then return end

	objEntry:ClearAllPoints()
	if not col.last then
		objEntry:SetPoint("TOPLEFT", layout.parent, "TOPLEFT", col.x, col.y)
	else
		objEntry:SetPoint("LEFT", col.last, "BOTTOMLEFT", 0, adjustY or -18)
	end

	col.last = objEntry
end

local function createHeader(parentFrame, text)
	local header = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	header:SetText(text)
	header:SetHeight(18)
	header:SetJustifyH("LEFT")
	return header
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

local function createSmallButton(parentFrame, displayText)
	buttonIndex = buttonIndex + 1

	local button = CreateFrame("Button", ADDON_NAME.."_config_button_" .. buttonIndex, parentFrame, "UIPanelButtonTemplate")
	button:SetText(displayText)
	button:SetHeight(22)
	button:SetWidth(button:GetTextWidth() + 18)

	return button
end

local sliderIndex = 0
local function createSlider(parentFrame, displayText, minVal, maxVal, setStep)
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
	slider:SetMinMaxValues(minVal or 0.5, maxVal or 5)
	slider:SetValue(0.5)
	slider:SetBackdrop(SliderBackdrop)
	slider:SetValueStep(setStep or 1)

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

local function openColorPicker(r, g, b, onChange, onCancel)
	if not ColorPickerFrame then
		onChange(r, g, b)
		DEFAULT_CHAT_FRAME:AddMessage(ADDON_NAME..": Color picker unavailable, using current color.")
		return
	end
	if ColorPickerFrame and ColorPickerFrame.SetupColorPickerAndShow then
		local info = {
			r = r, g = g, b = b,
			hasOpacity = false,
			swatchFunc = function()
				local nr, ng, nb = ColorPickerFrame:GetColorRGB()
				onChange(nr, ng, nb)
			end,
			cancelFunc = function(prev)
				if prev then onCancel(prev.r, prev.g, prev.b) end
			end,
		}
		ColorPickerFrame:SetupColorPickerAndShow(info)
	else
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame.previousValues = { r = r, g = g, b = b }
		ColorPickerFrame.func = function()
			local nr, ng, nb = ColorPickerFrame:GetColorRGB()
			onChange(nr, ng, nb)
		end
		ColorPickerFrame.cancelFunc = function(prev)
			if prev then onCancel(prev.r, prev.g, prev.b) end
		end
		ColorPickerFrame:SetColorRGB(r, g, b)
		ColorPickerFrame:Show()
	end
end

local function createColorSwatch(parentFrame, displayText)
	local swatch = CreateFrame("Button", nil, parentFrame)
	swatch:SetSize(260, 24)

	swatch.text = swatch:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	swatch.text:SetPoint("LEFT", swatch, "LEFT", 0, 0)
	swatch.text:SetJustifyH("LEFT")
	swatch.text:SetText(displayText)

	swatch.box = CreateFrame("Frame", nil, swatch, BackdropTemplateMixin and "BackdropTemplate")
	swatch.box:SetSize(18, 18)
	swatch.box:SetPoint("LEFT", swatch.text, "RIGHT", 10, 0)
	swatch.box.bg = swatch.box:CreateTexture(nil, "BACKGROUND")
	swatch.box.bg:SetAllPoints(swatch.box)

	return swatch
end

local function LoadAboutFrame()

	--Code inspired from tekKonfigAboutPanel
	local about = CreateFrame("Frame", ADDON_NAME.."AboutPanel", InterfaceOptionsFramePanelContainer, BackdropTemplateMixin and "BackdropTemplate")
	about.name = ADDON_NAME
	about:Hide()

    local fields = {"Version", "Author"}
	local notes = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Notes")

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
		local val = C_AddOns.GetAddOnMetadata(ADDON_NAME, field)
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

	if InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(about)
	else
		local category, layout = _G.Settings.RegisterCanvasLayoutCategory(about, about.name);
		_G.Settings.RegisterAddOnCategory(category);
		addon.settingsCategory = category
	end

	return about
end

function configFrame:EnableConfig()

	addon.aboutPanel = LoadAboutFrame()

	--scroll frame for options to prevent overflow
	local scrollFrame = CreateFrame("ScrollFrame", ADDON_NAME.."_ConfigScrollFrame", addon.aboutPanel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", addon.aboutPanel, "TOPLEFT", 12, -125)
	scrollFrame:SetPoint("BOTTOMRIGHT", addon.aboutPanel, "BOTTOMRIGHT", -34, 16)

	local content = CreateFrame("Frame", nil, scrollFrame)
	content:SetSize(1, 800)
	scrollFrame:SetScrollChild(content)
	content.scrollFrame = scrollFrame

	initLayout(content)

	local headerActions = createHeader(content, L.ConfigHeaderActions or "Actions")
	addConfigEntry(headerActions, -6)

	--anchor
	local btnAnchor = createButton(content, L.SlashAnchorText)
	btnAnchor.func = function()
		if XDT_Anchor:IsVisible() then
			XDT_Anchor:Hide()
			if canFocusT then
				XDT_FocusAnchor:Hide()
			end
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashAnchorOff)
		else
			XDT_Anchor:Show()
			if canFocusT then
				XDT_FocusAnchor:Show()
			end
			DEFAULT_CHAT_FRAME:AddMessage(L.SlashAnchorOn)
		end
	end
	btnAnchor:SetScript("OnClick", btnAnchor.func)

	addConfigEntry(btnAnchor, -20)
	addon.aboutPanel.btnAnchor = btnAnchor

	--reset
	local btnReset = createButton(content, L.SlashResetText)
	btnReset.func = function()
		DEFAULT_CHAT_FRAME:AddMessage(L.SlashResetAlert)
		XDT_Anchor:ClearAllPoints()
		XDT_Anchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		if canFocusT then
			XDT_FocusAnchor:ClearAllPoints()
			XDT_FocusAnchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		end
	end
	btnReset:SetScript("OnClick", btnReset.func)

	btnReset:ClearAllPoints()
	btnReset:SetPoint("LEFT", btnAnchor, "RIGHT", 12, 0)
	addon.aboutPanel.btnReset = btnReset

	--scale
	local sliderScale = createSlider(content, L.SlashScaleText, 0.5, 5, 0.1)
	sliderScale:SetScript("OnShow", function()
		sliderScale:SetValue(XDT_DB.scale)
		sliderScale.currVal:SetText("("..XDT_DB.scale..")")
	end)
	sliderScale.sliderFunc = function(self, value)
		value = math.floor(value * 10) / 10
		if value < 0.5 then value = 0.5 end --always make sure we are 0.5 as the highest zero.  Anything lower will make the frame dissapear
		if value > 5 then value = 5 end --nothing bigger than this
		sliderScale.currVal:SetText("("..value..")")
		sliderScale:SetValue(value)
	end
	sliderScale.sliderMouseUp = function(self, button)
		local value = math.floor(self:GetValue() * 10) / 10
		addon:SetAddonScale(value)
	end
	sliderScale:SetScript("OnValueChanged", sliderScale.sliderFunc)
	sliderScale:SetScript("OnMouseUp", sliderScale.sliderMouseUp)

	addConfigEntry(sliderScale, -36)
	addon.aboutPanel.sliderScale = sliderScale

	--bar color (under scale)
	local btnBarColor = createColorSwatch(content, L.BarColorText)
	btnBarColor:SetScript("OnShow", function()
		local clr = XDT_DB.barColor or { r = 0.75, g = 0, b = 0 }
		btnBarColor.box.bg:SetColorTexture(clr.r, clr.g, clr.b)
	end)
	btnBarColor.func = function()
		local clr = XDT_DB.barColor or { r = 0.75, g = 0, b = 0 }

		local function setColor(r, g, b)
			XDT_DB.barColor = { r = r, g = g, b = b }
			btnBarColor.box.bg:SetColorTexture(r, g, b)
			addon:ReloadDebuffs()
		end

		openColorPicker(clr.r, clr.g, clr.b, setColor, setColor)
	end
	btnBarColor:SetScript("OnClick", btnBarColor.func)

	addConfigEntry(btnBarColor, -32)
	addon.aboutPanel.btnBarColor = btnBarColor

	local btnBarColorReset = createSmallButton(content, L.Reset or "Reset")
	btnBarColorReset:SetPoint("LEFT", btnBarColor.box, "RIGHT", 16, 0)
	btnBarColorReset.func = function()
		XDT_DB.barColor = { r = 0.75, g = 0, b = 0 }
		btnBarColor.box.bg:SetColorTexture(XDT_DB.barColor.r, XDT_DB.barColor.g, XDT_DB.barColor.b)
		addon:ReloadDebuffs()
	end
	btnBarColorReset:SetScript("OnClick", btnBarColorReset.func)
	addon.aboutPanel.btnBarColorReset = btnBarColorReset

	--reload debuffs
	local btnReloadDebuffs = createButton(content, L.SlashReloadText)
	btnReloadDebuffs.func = function()
		addon:ReloadDebuffs()
		DEFAULT_CHAT_FRAME:AddMessage(L.SlashReloadAlert)
	end
	btnReloadDebuffs:SetScript("OnClick", btnReloadDebuffs.func)

	addConfigEntry(btnReloadDebuffs, -32)
	addon.aboutPanel.btnReloadDebuffs = btnReloadDebuffs

	local headerOptions = createHeader(content, L.ConfigHeaderOptions or "Options")
	addConfigEntry(headerOptions, -28)

	--graphic bar
	local btnGraphicBar = createCheckbutton(content, L.GraphicBarChkBtn)
	btnGraphicBar:SetScript("OnShow", function() btnGraphicBar:SetChecked(XDT_DB.useGraphicBar) end)
	btnGraphicBar.func = function(slashSwitch)
		local value = XDT_DB.useGraphicBar
		if not slashSwitch then value = XDT_DB.useGraphicBar end

		if value then
			XDT_DB.useGraphicBar = false
		else
			XDT_DB.useGraphicBar = true
		end

		addon:adjustBars()
		addon:ReloadDebuffs()
	end
	btnGraphicBar:SetScript("OnClick", btnGraphicBar.func)

	addConfigEntry(btnGraphicBar, -18)
	addon.aboutPanel.btnGraphicBar = btnGraphicBar

	--grow
	local btnGrow = createCheckbutton(content, L.SlashGrowChkBtn)
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

	addConfigEntry(btnGrow, -18)
	addon.aboutPanel.btnGrow = btnGrow

	--sort
	local btnSort = createCheckbutton(content, L.SlashSortChkBtn)
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

	addConfigEntry(btnSort, -14)
	addon.aboutPanel.btnSort = btnSort

	--infinite
	local btnInfinite = createCheckbutton(content, L.SlashInfiniteChkBtn)
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

	addConfigEntry(btnInfinite, -14)
	addon.aboutPanel.btnInfinite = btnInfinite

	--icon
	local btnIcon = createCheckbutton(content, L.IconChkBtn)
	btnIcon:SetScript("OnShow", function() btnIcon:SetChecked(XDT_DB.showIcon) end)
	btnIcon.func = function(slashSwitch)
		local value = XDT_DB.showIcon
		if not slashSwitch then value = XDT_DB.showIcon end

		if value then
			XDT_DB.showIcon = false
		else
			XDT_DB.showIcon = true
		end

		addon:adjustBars()
		addon:ReloadDebuffs()
	end
	btnIcon:SetScript("OnClick", btnIcon.func)

	addConfigEntry(btnIcon, -14)
	addon.aboutPanel.btnIcon = btnIcon

	--spellname
	local btnSpellName = createCheckbutton(content, L.SpellNameChkBtn)
	btnSpellName:SetScript("OnShow", function() btnSpellName:SetChecked(XDT_DB.showSpellName) end)
	btnSpellName.func = function(slashSwitch)
		local value = XDT_DB.showSpellName
		if not slashSwitch then value = XDT_DB.showSpellName end

		if value then
			XDT_DB.showSpellName = false

		else
			XDT_DB.showSpellName = true
		end

		addon:adjustBars()
		addon:ReloadDebuffs()
	end
	btnSpellName:SetScript("OnClick", btnSpellName.func)

	addConfigEntry(btnSpellName, -14)
	addon.aboutPanel.btnSpellName = btnSpellName

	--show on right
	local btnShowOnRight = createCheckbutton(content, L.ShowTimerOnRight)
	btnShowOnRight:SetScript("OnShow", function() btnShowOnRight:SetChecked(XDT_DB.showTimerOnRight) end)
	btnShowOnRight.func = function(slashSwitch)
		local value = XDT_DB.showTimerOnRight
		if not slashSwitch then value = XDT_DB.showTimerOnRight end

		if value then
			XDT_DB.showTimerOnRight = false
		else
			XDT_DB.showTimerOnRight = true
		end

		addon:adjustBars()
		addon:ReloadDebuffs()
	end
	btnShowOnRight:SetScript("OnClick", btnShowOnRight.func)

	addConfigEntry(btnShowOnRight, -14)
	addon.aboutPanel.btnShowOnRight = btnShowOnRight

	--hide in rested
	local btnHideInRested = createCheckbutton(content, L.HideInRested)
	btnHideInRested:SetScript("OnShow", function() btnHideInRested:SetChecked(XDT_DB.hideInRestedAreas) end)
	btnHideInRested.func = function(slashSwitch)
		local value = XDT_DB.hideInRestedAreas
		if not slashSwitch then value = XDT_DB.hideInRestedAreas end

		if value then
			XDT_DB.hideInRestedAreas = false
		else
			XDT_DB.hideInRestedAreas = true
		end

		addon:ReloadDebuffs()
	end
	btnHideInRested:SetScript("OnClick", btnHideInRested.func)

	addConfigEntry(btnHideInRested, -14)
	addon.aboutPanel.btnHideInRested = btnHideInRested
end
