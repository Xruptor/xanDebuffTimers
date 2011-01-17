--Inspired by TextTimers, Please give credit to Sagewind where possible

local timers = {}
local timersFocus = {}
local MAX_TIMERS = 15
local ICON_SIZE = 20
local BAR_ADJUST = 25
local BAR_TEXT = "llllllllllllllllllllllllllllllllllllllll"
local band = bit.band

local targetGUID = 0
local focusGUID = 0
local UnitAura = UnitAura
local UnitIsUnit = UnitIsUnit

local pointT = {
	["target"] = "XDT_Anchor",
	["focus"] = "XDT_FocusAnchor",
}

local f = CreateFrame("frame","xanDebuffTimers",UIParent)
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

----------------------
--      Enable      --
----------------------
	
function f:PLAYER_LOGIN()

	if not XDT_DB then XDT_DB = {} end
	if XDT_DB.scale == nil then XDT_DB.scale = 1 end
	if XDT_DB.grow == nil then XDT_DB.grow = false end
	if XDT_DB.sort == nil then XDT_DB.sort = false end

	--create our anchors
	f:CreateAnchor("XDT_Anchor", UIParent)
	f:CreateAnchor("XDT_FocusAnchor", UIParent)
	
	--create our timers
	for i=1,MAX_TIMERS do
		timers[i] = f:CreateDebuffTimers()
		timersFocus[i] = f:CreateDebuffTimers()
	end
	
	f:UnregisterEvent("PLAYER_LOGIN")
	f.PLAYER_LOGIN = nil
	
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	f:RegisterEvent("PLAYER_FOCUS_CHANGED")

	SLASH_XANDEBUFFTIMERS1 = "/xandebufftimers"
	SLASH_XANDEBUFFTIMERS2 = "/xdt"
	SLASH_XANDEBUFFTIMERS3 = "/xandt"
	SlashCmdList["XANDEBUFFTIMERS"] = function(msg)
	
		local a,b,c=strfind(msg, "(%S+)"); --contiguous string of non-space characters
		
		if a then
			if c and c:lower() == "anchor" then
				if XDT_Anchor:IsVisible() then
					XDT_Anchor:Hide()
					XDT_FocusAnchor:Hide()
				else
					XDT_Anchor:Show()
					XDT_FocusAnchor:Show()
				end
				return true
			elseif c and c:lower() == "scale" then
				if b then
					local scalenum = strsub(msg, b+2)
					if scalenum and scalenum ~= "" and tonumber(scalenum) then
						XDT_DB.scale = tonumber(scalenum)
						for i=1, MAX_TIMERS do
							timers[i]:SetScale(tonumber(scalenum))
							timersFocus[i]:SetScale(tonumber(scalenum))
						end
						DEFAULT_CHAT_FRAME:AddMessage("xanDebuffTimers: Scale has been set to ["..tonumber(scalenum).."]")
						return true
					end
				end
			elseif c and c:lower() == "grow" then
				if XDT_DB.grow then
					XDT_DB.grow = false
					DEFAULT_CHAT_FRAME:AddMessage("xanDebuffTimers: Bars will now grow [|cFF99CC33UP|r]")
				else
					XDT_DB.grow = true
					DEFAULT_CHAT_FRAME:AddMessage("xanDebuffTimers: Bars will now grow [|cFF99CC33DOWN|r]")
				end
				return true
			elseif c and c:lower() == "sort" then
				if XDT_DB.sort then
					XDT_DB.sort = false
					DEFAULT_CHAT_FRAME:AddMessage("xanDebuffTimers: Bars sort [|cFF99CC33DESCENDING|r]")
				else
					XDT_DB.sort = true
					DEFAULT_CHAT_FRAME:AddMessage("xanDebuffTimers: Bars sort [|cFF99CC33ASCENDING|r]")
				end
				return true
			end
		end

		DEFAULT_CHAT_FRAME:AddMessage("xanDebuffTimers")
		DEFAULT_CHAT_FRAME:AddMessage("/xdt anchor - toggles a movable anchor")
		DEFAULT_CHAT_FRAME:AddMessage("/xdt scale # - sets the scale size of the bars")
		DEFAULT_CHAT_FRAME:AddMessage("/xdt grow - changes the direction in which the bars grow (UP/DOWN)")
		DEFAULT_CHAT_FRAME:AddMessage("/xdt sort - changes the sorting of the bars. (ASCENDING/DESCENDING)")
	end
	
	local ver = tonumber(GetAddOnMetadata("xanDebuffTimers","Version")) or 'Unknown'
	DEFAULT_CHAT_FRAME:AddMessage("|cFF99CC33xanDebuffTimers|r [v|cFFDF2B2B"..ver.."|r] loaded: /xdt")
end
	
function f:PLAYER_TARGET_CHANGED()
	if UnitName("target") and UnitGUID("target") then
		targetGUID = UnitGUID("target")
		f:ProcessDebuffs("target", timers)
	else
		f:ClearDebuffs(timers)
		targetGUID = 0
	end
end

function f:PLAYER_FOCUS_CHANGED()
	if UnitName("focus") and UnitGUID("focus") then
		focusGUID = UnitGUID("focus")
		f:ProcessDebuffs("focus", timersFocus)
	else
		f:ClearDebuffs(timersFocus)
		focusGUID = 0
	end
end

local eventSwitch = {
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_AURA_REMOVED"] = true,
	["SPELL_AURA_REFRESH"] = true,
	["SPELL_AURA_APPLIED_DOSE"] = true,
	["SPELL_AURA_APPLIED_REMOVED_DOSE"] = true,
}

function f:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, spellSchool, auraType, amount)

    if eventType == "UNIT_DIED" or eventType == "UNIT_DESTROYED" then
		--clear the debuffs if the unit died
		--NOTE the reason an elseif isn't used is because some dorks may have
		--their current target as their focus as well
		if dstGUID == targetGUID then
			f:ClearDebuffs(timers)
			targetGUID = 0
		end
		if dstGUID == focusGUID then
			f:ClearDebuffs(timersFocus)
			focusGUID = 0
		end
		
	elseif eventSwitch[eventType] and band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 then
		--process the spells based on GUID
		if dstGUID == targetGUID then
			f:ProcessDebuffs("target", timers)
		end
		if dstGUID == focusGUID then
			f:ProcessDebuffs("focus", timersFocus)
		end
    end
end

----------------------
--  Frame Creation  --
----------------------

function f:CreateAnchor(name, parent)

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
			f:SaveLayout(frame:GetName())
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
	
	f:RestoreLayout(name)
end

local TimerOnUpdate = function(self, time)

	if self.active then
		self.OnUpdateCounter = (self.OnUpdateCounter or 0) + time
		if self.OnUpdateCounter < 0.05 then return end
		self.OnUpdateCounter = 0

		local beforeEnd = self.endTime - GetTime()
		local barLength = ceil( string.len(BAR_TEXT) * (beforeEnd / self.durationTime) )
		--check the string length JUST in case for errors
		if barLength > string.len(BAR_TEXT) then barLength = string.len(BAR_TEXT) end

		if barLength <= 0 then
			self.active = false
			self:Hide()
			f:ArrangeDebuffs(true, self.id)
			return               
		end
		
		self.tmpBL = barLength
		self.Bar:SetText( string.sub(BAR_TEXT, 1, barLength) )
		self.Bar:SetTextColor(f:getBarColor(self.durationTime, beforeEnd))
		if self.stacks > 0 then
			self.stacktext:SetText(self.stacks)
		else
			self.stacktext:SetText(nil)
		end
		self.timetext:SetText(f:GetTimeText(ceil(beforeEnd)))
		f:ArrangeDebuffs(true, self.id)
	end
	
end

function f:CreateDebuffTimers()
	
    local Frm = CreateFrame("Frame", nil, UIParent)
	
    Frm.active = false
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
    Frm.stacktext:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    Frm.stacktext:SetWidth(Frm.icon:GetWidth())
    Frm.stacktext:SetHeight(Frm.icon:GetHeight())
    Frm.stacktext:SetJustifyH("RIGHT")
    Frm.stacktext:SetVertexColor(1,1,1)
    Frm.stacktext:SetPoint("RIGHT", Frm.icon, "RIGHT",1,-5)
    
    Frm.timetext = Frm:CreateFontString(nil, "OVERLAY");
    Frm.timetext:SetFont("Fonts\\FRIZQT__.TTF",10,"OUTLINE")
    Frm.timetext:SetJustifyH("RIGHT")
    Frm.timetext:SetPoint("RIGHT", Frm.icon, "LEFT" , -5, 0)

	Frm.Bar = Frm:CreateFontString(nil, "GameFontNormal")
	Frm.Bar:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE, MONOCHROME")
	Frm.Bar:SetText(BAR_TEXT)
	Frm.Bar:SetPoint("LEFT", Frm.icon, "RIGHT", 1, 0)
		
    Frm:SetScript("OnUpdate", TimerOnUpdate)

	Frm:Hide()
    
	return Frm
	
end

----------------------
-- Debuff Functions --
----------------------

function f:ProcessDebuffs(sT, sdTimer)
	--only process for as many timers as we are using
	local countBuffs = 0
	for i=1, MAX_TIMERS do
		local name, _, icon, count, _, duration, expTime, unitCaster, _, _, spellId = UnitAura(sT, i, 'HARMFUL|PLAYER')
		--UnitIsUnit is used JUST IN CASE (you never know lol)
		--check for duration > 0 for the evil DIVIDE BY ZERO
		if name and unitCaster and UnitIsUnit(unitCaster, "player") and duration > 0 then
			sdTimer[i].id = sT
			sdTimer[i].spellName = name
			sdTimer[i].spellId = spellId
			sdTimer[i].iconTex = icon
			sdTimer[i].icon:SetTexture(icon)
			sdTimer[i].startTime = expTime - duration
			sdTimer[i].durationTime = duration
			sdTimer[i].endTime = expTime
			sdTimer[i].stacks = count or 0
				local tmpBL = ceil( string.len(BAR_TEXT) * ( (expTime - GetTime()) / duration ) )
				if tmpBL > string.len(BAR_TEXT) then tmpBL = string.len(BAR_TEXT) end
			sdTimer[i].tmpBL = tmpBL
			sdTimer[i].active = true
			if not sdTimer[i]:IsVisible() then sdTimer[i]:Show() end
			countBuffs = countBuffs + 1
		else
			sdTimer[i].active = false
			if sdTimer[i]:IsVisible() then sdTimer[i]:Hide() end
		end
	end
	if countBuffs > 0 then
		f:ArrangeDebuffs(false, sT)
	end
end

function f:ClearDebuffs(sdTimer)
	local adj = 0

	for i=1, MAX_TIMERS do
		if sdTimer[i].active then
			sdTimer[i].active = false
		end
		--reset the order
		if XDT_DB.grow then
			sdTimer[i]:ClearAllPoints()
			sdTimer[i]:SetPoint("TOPLEFT", pointT[sdTimer[i].id], "BOTTOMRIGHT", 0, adj)
		else
			sdTimer[i]:ClearAllPoints()
			sdTimer[i]:SetPoint("BOTTOMLEFT",  pointT[sdTimer[i].id], "TOPRIGHT", 0, (adj * -1))
		end
		adj = adj - BAR_ADJUST

		if sdTimer[i]:IsVisible() then sdTimer[i]:Hide() end
	end
	
end

function f:ArrangeDebuffs(throttle, id)
	--to prevent spam and reduce CPU use
	if throttle then
		if not f.ADT then f.ADT = GetTime() end
		if (GetTime() - f.ADT) < 0.1 then
			return
		end
		f.ADT = GetTime()
	end

	local adj = 0
	local sdTimer
	
	if id == "target" then
		sdTimer = timers
	elseif id == "focus" then
		sdTimer = timersFocus
	else
		return
	end
	
	if XDT_DB.grow then
		--bars will grow down
		if XDT_DB.sort then
			--sort from shortest to longest
			table.sort(sdTimer, function(a,b)
				if a.active == true and b.active == false then
					return true;
				elseif a.active and b.active then
					return (a.tmpBL < b.tmpBL);
				end
				return false;
			end)
		else
			--sort from longest to shortest
			table.sort(sdTimer, function(a,b)
				if a.active == true and b.active == false then
					return true;
				elseif a.active and b.active then
					return (a.tmpBL > b.tmpBL);
				end
				return false;
			end)
		end
	else
		--bars will grow up
		if XDT_DB.sort then
			--sort from shortest to longest
			table.sort(sdTimer, function(a,b)
				if a.active == true and b.active == false then
					return true;
				elseif a.active and b.active then
					return (a.tmpBL > b.tmpBL);
				end
				return false;
			end)
		else
			--sort from longest to shortest
			table.sort(sdTimer, function(a,b)
				if a.active == true and b.active == false then
					return true;
				elseif a.active and b.active then
					return (a.tmpBL < b.tmpBL);
				end
				return false;
			end)
		end
	end

	--rearrange order
	for i=1, #sdTimer do
		if XDT_DB.grow then
			sdTimer[i]:ClearAllPoints()
			sdTimer[i]:SetPoint("TOPLEFT", pointT[sdTimer[i].id], "BOTTOMRIGHT", 0, adj)
		else
			sdTimer[i]:ClearAllPoints()
			sdTimer[i]:SetPoint("BOTTOMLEFT", pointT[sdTimer[i].id], "TOPRIGHT", 0, (adj * -1))
		end
		adj = adj - BAR_ADJUST
    end
	
end

----------------------
-- Local Functions  --
----------------------
	
function f:SaveLayout(frame)

	if not XDT_DB then XDT_DB = {} end

	local opt = XDT_DB[frame] or nil;

	if opt == nil then
		XDT_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["PosX"] = 0,
			["PosY"] = 0,
		}
		opt = XDT_DB[frame];
	end

	local f = getglobal(frame);
	local scale = f:GetEffectiveScale();
	opt.PosX = f:GetLeft() * scale;
	opt.PosY = f:GetTop() * scale;
	
end

function f:RestoreLayout(frame)

	if not XDT_DB then XDT_DB = {} end
	
	local f = getglobal(frame);
	local opt = XDT_DB[frame] or nil;

	if opt == nil then
		XDT_DB[frame] = {
			["point"] = "CENTER",
			["relativePoint"] = "CENTER",
			["PosX"] = 0,
			["PosY"] = 0,
			["firsttime"] = true,
		}
		opt = XDT_DB[frame]
	end

	local x = opt.PosX;
	local y = opt.PosY;
	local s = f:GetEffectiveScale()

	if not x or not y or opt.firsttime then
		f:ClearAllPoints()
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		if opt.firsttime then opt.firsttime = nil end
		return 
	end

	--calculate the scale
	x,y = x/s, y/s

	--set the location
	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)

end

function f:getBarColor(dur, expR)
	local r
	local g = 1
	local cur = 2 * expR/dur
	if cur > 1 then
		return 2 - cur, 1, 0
	else
		return 1, cur, 0
	end
end

function f:GetTimeText(timeLeft)
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
		return string.format("%dh",hours)
	elseif minutes > 0 then
		return string.format("%dm",minutes)
	elseif seconds > 0 then
		return string.format("%ds",seconds)
	else
		return nil
	end
end
		
if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
