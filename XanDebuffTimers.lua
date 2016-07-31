
local timers = {}
local timersFocus = {}
local MAX_TIMERS = 15
local ICON_SIZE = 20
local BAR_ADJUST = 25
local BAR_TEXT = "llllllllllllllllllllllllllllllllllllllll"
local band = bit.band
local locked = false

local targetGUID = 0
local focusGUID = 0
local UnitAura = UnitAura
local UnitIsUnit = UnitIsUnit
local UnitGUID = UnitGUID
local UnitName = UnitName

local pointT = {
	["target"] = "XDT_Anchor",
	["focus"] = "XDT_FocusAnchor",
}

local f = CreateFrame("frame","xanDebuffTimers",UIParent)
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

local debugf = tekDebug and tekDebug:GetFrame("xanDebuffTimers")
local function Debug(...)
    if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end
end

----------------------
--      Enable      --
----------------------
	
function f:PLAYER_LOGIN()

	if not XDT_DB then XDT_DB = {} end
	if XDT_DB.scale == nil then XDT_DB.scale = 1 end
	if XDT_DB.grow == nil then XDT_DB.grow = false end
	if XDT_DB.sort == nil then XDT_DB.sort = false end

	--create our anchors
	f:CreateAnchor("XDT_Anchor", UIParent, "xanDebuffTimers: Target Anchor")
	f:CreateAnchor("XDT_FocusAnchor", UIParent, "xanDebuffTimers: Focus Anchor")

	--create our bars
	f:generateBars()
	
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
							if timers[i] then
								timers[i]:SetScale(tonumber(scalenum))
							end
							if timersFocus[i] then
								timersFocus[i]:SetScale(tonumber(scalenum))
							end
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
}

function f:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventType, hideCaster, sourceGUID, sourceName, srcFlags, sourceRaidFlags, dstGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, auraType, amount)

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

function f:CreateAnchor(name, parent, desc)

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

local TimerOnUpdate = function(self, elasped)

	if self.active then
		self.OnUpdateCounter = (self.OnUpdateCounter or 0) + elasped
		if self.OnUpdateCounter < 0.05 then return end
		self.OnUpdateCounter = 0
		
		local beforeEnd = self.data.endTime - GetTime()
		
		--calculate the individual bar segments and make the appropriate calculations
		local totalDuration = (self.data.endTime - self.data.startTime) --total duration of the spell
		local totalBarSegment = (string.len(BAR_TEXT) / totalDuration) --lets get how much each segment of the bar string would value up to 100%
		local totalBarLength = totalBarSegment * beforeEnd --now get the individual bar segment value and multiply it with current duration
		local barPercent = (totalBarLength / string.len(BAR_TEXT)) * 100
		
		-- local percentTotal = (beforeEnd / self.data.durationTime)
		-- local percentFinal = ceil(percentTotal * 100)
		-- local barLength = ceil( string.len(BAR_TEXT) * percentTotal )
		
		--100/40 means each segment is 2.5 for 100%
		
		--example for 50%   50/100 = 0.5   0.5 / 2.5 = 0.2  (50% divided by segment count) 0.2 * 100 = 20 (which is half of the bar of 40)
		--local testBar = ((percentFinal / 100) / 2.5) * 100
		
		--Debug("(2) Spell("..self.data.spellName..") totalDuration: "..tostring(ceil(totalDuration)).."  |  totalBarSegment: "..tostring(ceil(totalBarSegment)).."  |  totalBarLength: "..tostring(ceil(totalBarLength)).."  |  barPercent: "..tostring(ceil(barPercent)))
		
		--Debug("(3) Spell("..self.data.spellName..") Time: "..tostring(GetTime()).."  |  percentTotal: "..tostring(ceil(percentTotal)).."  |  PercentFinal: "..tostring(percentFinal).."  |  totalBarLength: "..tostring(totalBarLength).."  |  TextTime: "..tostring(ceil(beforeEnd)))
	
		--Debug("(4) Spell("..self.data.spellName..") Time: "..tostring(GetTime()).."  |  beforeEnd: "..tostring(ceil(beforeEnd)).."  |  totalBarLength: "..tostring(totalBarLength).."  |  Testing: "..tostring(testing))
		
		if barPercent <= 0 or beforeEnd <= 0 or totalBarLength <= 0 then
			self.active = false
			f:ArrangeDebuffs(true, self.id)
			return               
		end
		
		self.data.percent = barPercent
		self.data.totalBarLength = totalBarLength
		self.data.beforeEnd = beforeEnd
		
		self.Bar:SetText( string.sub(BAR_TEXT, 1, totalBarLength) )
		self.Bar:SetTextColor(f:getBarColor(self.data.durationTime, beforeEnd))
		self.icon:SetTexture(self.data.iconTex)
		if self.data.stacks > 0 then
			self.stacktext:SetText(self.data.stacks)
		else
			self.stacktext:SetText(nil)
		end
		self.timetext:SetText(f:GetTimeText(ceil(beforeEnd)))
		f:ArrangeDebuffs(true, self.id)
		
	end
	
end

function f:CreateDebuffTimers()
	
    local Frm = CreateFrame("Frame", nil, UIParent)
	
	Frm.data = {}
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

function f:generateBars()
	local adj = 0
	
	--lets create the max bars to use on screen for future sorting
	for i=1, MAX_TIMERS do
		timers[i] = f:CreateDebuffTimers()
		timersFocus[i] = f:CreateDebuffTimers()
	end
		
	--rearrange order
	for i=1, MAX_TIMERS do
		if XDT_DB.grow then
			timers[i]:ClearAllPoints()
			timers[i]:SetPoint("TOPLEFT", XDT_Anchor, "BOTTOMRIGHT", 0, adj)
			timersFocus[i]:ClearAllPoints()
			timersFocus[i]:SetPoint("TOPLEFT", XDT_FocusAnchor, "BOTTOMRIGHT", 0, adj)			
		else
			timers[i]:ClearAllPoints()
			timers[i]:SetPoint("BOTTOMLEFT", XDT_Anchor, "TOPRIGHT", 0, (adj * -1))
			timersFocus[i]:ClearAllPoints()
			timersFocus[i]:SetPoint("BOTTOMLEFT", XDT_FocusAnchor, "TOPRIGHT", 0, (adj * -1))			
		end
		adj = adj - BAR_ADJUST
    end

end

	
----------------------
-- Debuff Functions --
----------------------

function f:ProcessDebuffs(sT, sdTimer)
	--only process for as many timers as we are using
	for i=1, MAX_TIMERS do
		local name, _, icon, count, _, duration, expTime, unitCaster, _, _, spellId = UnitAura(sT, i, 'PLAYER|HARMFUL')
		--check for duration > 0 for the evil DIVIDE BY ZERO
		if name and duration and duration > 0 then
			local beforeEnd = expTime - GetTime()
			local startTime = (expTime - duration)
			local totalDuration = (expTime - startTime) --total duration of the spell
			local totalBarSegment = (string.len(BAR_TEXT) / totalDuration) --lets get how much each segment of the bar string would value up to 100%
			local totalBarLength = totalBarSegment * beforeEnd --now get the individual bar segment value and multiply it with current duration
			local barPercent = (totalBarLength / string.len(BAR_TEXT)) * 100
		
			if barPercent > 0 or beforeEnd > 0 or totalBarLength > 0 then
				--data
				sdTimer[i].data.id = sT
				sdTimer[i].data.spellName = name
				sdTimer[i].data.spellId = spellId
				sdTimer[i].data.iconTex = icon
				sdTimer[i].data.startTime = startTime
				sdTimer[i].data.durationTime = duration
				sdTimer[i].data.beforeEnd = beforeEnd
				sdTimer[i].data.endTime = expTime
				sdTimer[i].data.totalBarLength = totalBarLength
				sdTimer[i].data.stacks = count or 0
				sdTimer[i].data.percent = barPercent
				
				sdTimer[i].id = sT
				sdTimer[i].icon:SetTexture(icon)
				sdTimer[i].active = true
				--Debug("(1) Time: "..tostring(GetTime()).."  |  Start: "..tostring(expTime - duration).."  |  Duration: "..tostring(duration).."  |  Expiration: "..tostring(expTime))
				--Debug("<Percentage> "..tostring(sdTimer[slotNum].percent) )
			end
		else
			sdTimer[i].active = false
		end
	end
	
	f:ArrangeDebuffs(false, sT)
end

function f:ClearDebuffs(sdTimer)
	local adj = 0

	for i=1, MAX_TIMERS do
		sdTimer[i].active = false
		sdTimer[i]:Hide()
	end
	
end

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function f:ArrangeDebuffs(throttle, id)
	--to prevent spam and reduce CPU use
	if throttle then
		if not f.ADT then f.ADT = GetTime() end
		if (GetTime() - f.ADT) < 1 then
			return
		end
		f.ADT = GetTime()
	end
	
	if locked then return end
	locked = true
	
	local adj = 0
	local sdTimer
	local tmpList = {}
	
	if id == "target" then
		sdTimer = timers
	elseif id == "focus" then
		sdTimer = timersFocus
	else
		locked = false
		return
	end
	
	for i=1, MAX_TIMERS do
		if sdTimer[i].active then
			table.insert(tmpList, deepcopy(sdTimer[i].data))
			Debug(i)
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
	
	for i=1, MAX_TIMERS do
		if tmpList[i] then
			sdTimer[i].data = tmpList[i]
			sdTimer[i]:Show()
		else
			sdTimer[i].active = false
			sdTimer[i]:Hide()
		end
    end
	Debug("----")

	locked = false
end

----------------------
-- Local Functions  --
----------------------
	
	
function f:SaveLayout(frame)
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

function f:RestoreLayout(frame)
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
		hours = ceil(timeLeft / 3600)
		timeLeft = mod(timeLeft, 3600)
	end

	if( timeLeft >= 60 ) then
		minutes = ceil(timeLeft / 60)
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
