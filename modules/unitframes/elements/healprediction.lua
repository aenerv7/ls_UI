local _, ns = ...
local E, C, M, L, P = ns.E, ns.C, ns.M, ns.L, ns.P
local UF = P:GetModule("UnitFrames")

-- Lua
local _G = _G
local unpack = unpack

-- Mine
local function UpdateHealPredictionAnchor(self, orientation, appendTexture)
	if orientation == "HORIZONTAL" then
		self:SetPoint("LEFT", appendTexture, "RIGHT")
	else
		self:SetPoint("BOTTOM", appendTexture, "TOP")
	end

	if self.Overlay then
		if self:GetValue() == 0 then
			self.Overlay:Hide()
		else
			self.Overlay:Show()
		end
	end

	return self:GetStatusBarTexture()
end

local function PostUpdateHealPrediction(self, unit, overAbsorb, overHealAbsorb)
	local myHeals = self.myBar
	local otherHeals = self.otherBar
	local damageAbsorb = self.absorbBar
	local absorbGlow = self.__owner.AbsorbGlow
	local appendTexture = self.__owner.Health:GetStatusBarTexture()
	local orientation = self.myBar:GetOrientation()

	if myHeals and myHeals:GetValue() > 0 then
		appendTexture = UpdateHealPredictionAnchor(myHeals, orientation, appendTexture)
	end

	if otherHeals and otherHeals:GetValue() > 0 then
		appendTexture = UpdateHealPredictionAnchor(otherHeals, orientation, appendTexture)
	end

	if damageAbsorb then
		appendTexture = UpdateHealPredictionAnchor(damageAbsorb, orientation, appendTexture)
	end

	if absorbGlow then
		if overAbsorb then
			E:Blink(absorbGlow, 0.5, 0, 1)
		else
			E:StopBlink(absorbGlow)
		end
	end
end

function UF:CreateHealPrediction_new(parent, options)
	P.argcheck(1, parent, "table")

	options = options or {}

	local level = parent:GetFrameLevel()
	local width, height = parent:GetSize()

	local myBar = _G.CreateFrame("StatusBar", "$parentMyIncomingHeal", parent)
	myBar:SetFrameLevel(level)
	myBar:SetOrientation(options.is_vertical and "VERTICAL" or "HORIZONTAL")
	myBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	myBar:SetStatusBarColor(M.COLORS.HEALPREDICTION.MY_HEAL:GetRGB())
	myBar:Hide()

	local otherBar = _G.CreateFrame("StatusBar", "$parentOtherIncomingHeal", parent)
	otherBar:SetFrameLevel(level)
	otherBar:SetOrientation(options.is_vertical and "VERTICAL" or "HORIZONTAL")
	otherBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	otherBar:SetStatusBarColor(M.COLORS.HEALPREDICTION.OTHER_HEAL:GetRGB())
	otherBar:Hide()

	local healAbsorbBar = _G.CreateFrame("StatusBar", "$parentHealAbsorb", parent)
	healAbsorbBar:SetReverseFill(true)
	healAbsorbBar:SetFrameLevel(level + 1)
	healAbsorbBar:SetOrientation(options.is_vertical and "VERTICAL" or "HORIZONTAL")
	healAbsorbBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	healAbsorbBar:SetStatusBarColor(M.COLORS.HEALPREDICTION.HEAL_ABSORB:GetRGB())
	healAbsorbBar:Hide()

	local damageAbsorbBar = _G.CreateFrame("StatusBar", "$parentTotalAbsorb", parent)
	damageAbsorbBar:SetFrameLevel(level + 1)
	damageAbsorbBar:SetOrientation(options.is_vertical and "VERTICAL" or "HORIZONTAL")
	damageAbsorbBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	-- damageAbsorbBar:SetStatusBarColor(M.COLORS.HEALPREDICTION.DAMAGE_ABSORB:GetRGB())
	damageAbsorbBar:Hide()

	damageAbsorbBar.Overlay = damageAbsorbBar:CreateTexture(nil, "ARTWORK", "TotalAbsorbBarOverlayTemplate", 1)
	damageAbsorbBar.Overlay:SetAllPoints(damageAbsorbBar:GetStatusBarTexture())

	if options.is_vertical then
		myBar:SetPoint("LEFT")
		myBar:SetPoint("RIGHT")
		myBar:SetHeight(height)

		otherBar:SetPoint("LEFT")
		otherBar:SetPoint("RIGHT")
		otherBar:SetHeight(height)

		healAbsorbBar:SetPoint("LEFT")
		healAbsorbBar:SetPoint("RIGHT")
		healAbsorbBar:SetPoint("TOP", parent:GetStatusBarTexture(), "TOP")
		healAbsorbBar:SetHeight(height)

		damageAbsorbBar:SetPoint("LEFT")
		damageAbsorbBar:SetPoint("RIGHT")
		damageAbsorbBar:SetHeight(height)
	else
		myBar:SetPoint("TOP")
		myBar:SetPoint("BOTTOM")
		myBar:SetWidth(width)

		otherBar:SetPoint("TOP")
		otherBar:SetPoint("BOTTOM")
		otherBar:SetWidth(width)

		healAbsorbBar:SetPoint("TOP")
		healAbsorbBar:SetPoint("BOTTOM")
		healAbsorbBar:SetPoint("RIGHT", parent:GetStatusBarTexture(), "RIGHT")
		healAbsorbBar:SetWidth(width)

		damageAbsorbBar:SetPoint("TOP")
		damageAbsorbBar:SetPoint("BOTTOM")
		damageAbsorbBar:SetWidth(width)
	end

	return {
		myBar = myBar,
		otherBar = otherBar,
		healAbsorbBar = healAbsorbBar,
		absorbBar = damageAbsorbBar,
		maxOverflow = 1,
		frequentUpdates = true,
		PostUpdate = PostUpdateHealPrediction
	}
end

function UF:CreateHealPrediction(parent, isVertical)
	local healthbar = parent.Health
	local level = healthbar:GetFrameLevel()
	local width, height = healthbar:GetSize()

	local myBar = _G.CreateFrame("StatusBar", "$parentMyIncomingHeal", healthbar)
	myBar:SetFrameLevel(level)
	myBar:SetOrientation(isVertical and "VERTICAL" or "HORIZONTAL")
	myBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	myBar:SetStatusBarColor(M.COLORS.HEALPREDICTION.MY_HEAL:GetRGB())
	myBar:Hide()

	local otherBar = _G.CreateFrame("StatusBar", "$parentOtherIncomingHeal", healthbar)
	otherBar:SetFrameLevel(level)
	otherBar:SetOrientation(isVertical and "VERTICAL" or "HORIZONTAL")
	otherBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	otherBar:SetStatusBarColor(M.COLORS.HEALPREDICTION.OTHER_HEAL:GetRGB())
	otherBar:Hide()

	local healAbsorbBar = _G.CreateFrame("StatusBar", "$parentHealAbsorb", healthbar)
	healAbsorbBar:SetReverseFill(true)
	healAbsorbBar:SetFrameLevel(level + 1)
	healAbsorbBar:SetOrientation(isVertical and "VERTICAL" or "HORIZONTAL")
	healAbsorbBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	healAbsorbBar:SetStatusBarColor(M.COLORS.HEALPREDICTION.HEAL_ABSORB:GetRGB())
	healAbsorbBar:Hide()

	local damageAbsorbBar = _G.CreateFrame("StatusBar", "$parentTotalAbsorb", healthbar)
	damageAbsorbBar:SetFrameLevel(level + 1)
	damageAbsorbBar:SetOrientation(isVertical and "VERTICAL" or "HORIZONTAL")
	damageAbsorbBar:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	-- damageAbsorbBar:SetStatusBarColor(M.COLORS.HEALPREDICTION.DAMAGE_ABSORB:GetRGB())
	damageAbsorbBar:Hide()

	damageAbsorbBar.Overlay = damageAbsorbBar:CreateTexture(nil, "ARTWORK", "TotalAbsorbBarOverlayTemplate", 1)
	damageAbsorbBar.Overlay:SetAllPoints(damageAbsorbBar:GetStatusBarTexture())

	if isVertical then
		myBar:SetPoint("LEFT")
		myBar:SetPoint("RIGHT")
		myBar:SetHeight(height)

		otherBar:SetPoint("LEFT")
		otherBar:SetPoint("RIGHT")
		otherBar:SetHeight(height)

		healAbsorbBar:SetPoint("LEFT")
		healAbsorbBar:SetPoint("RIGHT")
		healAbsorbBar:SetPoint("TOP", healthbar:GetStatusBarTexture(), "TOP")
		healAbsorbBar:SetHeight(height)

		damageAbsorbBar:SetPoint("LEFT")
		damageAbsorbBar:SetPoint("RIGHT")
		damageAbsorbBar:SetHeight(height)
	else
		myBar:SetPoint("TOP")
		myBar:SetPoint("BOTTOM")
		myBar:SetWidth(width)

		otherBar:SetPoint("TOP")
		otherBar:SetPoint("BOTTOM")
		otherBar:SetWidth(width)

		healAbsorbBar:SetPoint("TOP")
		healAbsorbBar:SetPoint("BOTTOM")
		healAbsorbBar:SetPoint("RIGHT", healthbar:GetStatusBarTexture(), "RIGHT")
		healAbsorbBar:SetWidth(width)

		damageAbsorbBar:SetPoint("TOP")
		damageAbsorbBar:SetPoint("BOTTOM")
		damageAbsorbBar:SetWidth(width)
	end

	return {
		myBar = myBar,
		otherBar = otherBar,
		healAbsorbBar = healAbsorbBar,
		absorbBar = damageAbsorbBar,
		maxOverflow = 1,
		frequentUpdates = true,
		PostUpdate = PostUpdateHealPrediction
	}
end
