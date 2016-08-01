local _, ns = ...
local E, C, M, L = ns.E, ns.C, ns.M, ns.L

-- Lua
local _G = _G

-- Blizz
local GetTime = GetTime

-- Mine
local THRESHOLD = 1.5

local function Timer_OnUpdate(self, elapsed)
	if not self.Timer:IsShown() then return end

	self.elapsed = (self.elapsed or 0) + elapsed

	if self.elapsed > 0.1 then
		local timer = self.Timer

		local time, color, abbr = E:TimeFormat(timer.duration + timer.start - GetTime(), true)

		if time >= 0.1 then
			timer:SetFormattedText("%s"..abbr.."|r", color, time)
		else
			timer:SetText("")
			timer:Hide()
		end

		self.elapsed = 0
	end
end

local function SetCustomCooldown(self, start, duration)
	local timer = self.Timer

	if start > 0 and duration > THRESHOLD then
		timer.start = start
		timer.duration = duration
		timer:Show()

		self:SetScript("OnUpdate", Timer_OnUpdate)
	else
		timer:Hide()

		self:SetScript("OnUpdate", nil)
	end
end

local function CreateCooldownTimer(cooldown, textSize)
	local holder = _G.CreateFrame("Frame", "$parentTextHolder", cooldown)
	holder:SetFrameLevel(6)
	holder:SetAllPoints()

	local timer = E:CreateFontString(holder, textSize, nil, nil, true)
	timer:SetPoint("CENTER", 1, 0)
	timer:SetJustifyH("CENTER")

	return timer

end

local function SetTimerTextHeight(self, height)
	self.Timer:SetFontObject("LS"..height.."Font_Outline")
end

function E:CreateCooldown(parent, textSize)
	local cooldown = _G.CreateFrame("Cooldown", "$parentCooldown", parent, "CooldownFrameTemplate")
	cooldown:SetPoint("TOPLEFT", 1, -1)
	cooldown:SetPoint("BOTTOMRIGHT", -1, 1)
	E:HandleCooldown(cooldown, textSize)

	return cooldown
end

function E:HandleCooldown(cooldown, textSize)
	if E.OMNICC or cooldown.handled then return end

	cooldown:SetDrawEdge(false)
	cooldown:SetHideCountdownNumbers(true)

	cooldown.Timer = CreateCooldownTimer(cooldown, textSize)
	cooldown.SetTimerTextHeight = SetTimerTextHeight

	local text = cooldown:GetRegions()
	text:SetAlpha(0)

	_G.hooksecurefunc(cooldown, "SetCooldown", SetCustomCooldown)

	cooldown.handled = true
end
