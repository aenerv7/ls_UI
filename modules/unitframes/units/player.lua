local _, ns = ...
local E, C, M, L, P = ns.E, ns.C, ns.M, ns.L, ns.P
local UF = P:GetModule("UnitFrames")

function UF:ConstructPlayerFrame(frame)
	tinsert(UF.framesByUnit["player"], frame)

	local level = frame:GetFrameLevel()

	frame.mouseovers = {}
	frame:SetSize(164, 164)

	local bg = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	bg:SetTexture("Interface\\AddOns\\ls_UI\\media\\frame-player-bg")
	bg:SetTexCoord(1 / 256, 105 / 256, 1 / 256, 151 / 256)
	bg:SetSize(104, 150)
	bg:SetPoint("CENTER")

	local mid = CreateFrame("Frame", "$parentMiddle", frame)
	mid:SetFrameLevel(level + 3)
	mid:SetAllPoints()

	local ring = mid:CreateTexture(nil, "BACKGROUND", nil, 1)
	ring:SetTexture("Interface\\AddOns\\ls_UI\\media\\frame-player-main")
	ring:SetTexCoord(1 / 256, 169 / 256, 1 / 256, 203 / 256)
	ring:SetSize(168, 202)
	ring:SetPoint("CENTER", 0, -17)

	local cover = CreateFrame("Frame", "$parentCover", frame)
	cover:SetFrameLevel(level + 6)
	cover:SetAllPoints()
	frame.Cover = cover

	local tube = cover:CreateTexture(nil, "ARTWORK", nil, 0)
	tube:SetTexture("Interface\\AddOns\\ls_UI\\media\\frame-player-classpower")
	tube:SetTexCoord(1 / 512, 21 / 512, 1 / 256, 129 / 256)
	tube:SetSize(20, 128)
	tube:SetPoint("LEFT", 15, 0)
	cover.Tube = tube

	local sep = cover:CreateTexture(nil, "ARTWORK", nil, 1)
	sep:SetTexture("Interface\\AddOns\\ls_UI\\media\\frame-player-classpower")
	sep:SetSize(20, 128)
	sep:SetPoint("LEFT", 15, 0)
	cover.Sep = sep

	local fg = cover:CreateTexture(nil, "ARTWORK", nil, 2)
	fg:SetTexture("Interface\\AddOns\\ls_UI\\media\\frame-player-fg")
	fg:SetTexCoord(1 / 256, 151 / 256, 1 / 256, 151 / 256)
	fg:SetSize(150, 150)
	fg:SetPoint("CENTER")

	local health = UF:CreateHealthBar(frame, 18, nil, true)
	health:SetFrameLevel(level + 1)
	health:SetSize(94, 132)
	health:SetPoint("CENTER")
	tinsert(frame.mouseovers, health)
	frame.Health = health

	local healthText = health.Text
	healthText:SetParent(cover)
	healthText:SetJustifyH("RIGHT")
	healthText:SetPoint("CENTER", 0, 8)

	frame.HealPrediction = UF:CreateHealPrediction(frame, true)

	local absrobGlow = cover:CreateTexture(nil, "ARTWORK", nil, 1)
	absrobGlow:SetTexture("Interface\\AddOns\\ls_UI\\media\\frame-player-absorb")
	absrobGlow:SetTexCoord(1 / 128, 103 / 128, 1 / 64, 41 / 64)
	absrobGlow:SetVertexColor(0.35, 1, 1)
	absrobGlow:SetSize(102, 40)
	absrobGlow:SetPoint("CENTER", 0, 54)
	absrobGlow:SetAlpha(0)
	frame.AbsorbGlow = absrobGlow

	local damageAbsorb = E:CreateFontString(cover, 12, "$parentDamageAbsorbsText", true)
	damageAbsorb:SetPoint("CENTER", 0, 24)
	frame:Tag(damageAbsorb, "[ls:damageabsorb]")

	local healAbsorb = E:CreateFontString(cover, 12, "$parentHealAbsorbsText", true)
	healAbsorb:SetPoint("CENTER", 0, 38)
	frame:Tag(healAbsorb, "[ls:healabsorb]")

	local power = UF:CreatePowerBar(frame, 14, nil, true)
	power:SetFrameLevel(level + 4)
	power:SetSize(12, 128)
	power:SetPoint("RIGHT", -19, 0)
	tinsert(frame.mouseovers, power)
	frame.Power = power

	local pwrCover = CreateFrame("Frame", "$parentCover", power)
	pwrCover:SetAllPoints()
	E:SetBarSkin(pwrCover, "VERTICAL-L")

	local powerText = power.Text
	powerText:SetParent(cover)
	powerText:SetPoint("CENTER", 0, -8)

	local altMana = CreateFrame("StatusBar", "$parentDruidPowerBar", frame)
	altMana:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	altMana:SetOrientation("VERTICAL")
	altMana:SetFrameLevel(level + 7)
	altMana:SetSize(8, 106)
	altMana:SetPoint("RIGHT", -7, 0)
	altMana.colorPower = true
	frame.AdditionalPower = altMana

	local dmMana = CreateFrame("Frame", "$parentCover", altMana)
	dmMana:SetAllPoints()
	E:SetBarSkin(dmMana, "VERTICAL-M")

	local mainPCP = CreateFrame("StatusBar", "$parentPowerCostPrediction", power)
	mainPCP:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	mainPCP:SetStatusBarColor(0.55, 0.75, 0.95)
	mainPCP:SetOrientation("VERTICAL")
	mainPCP:SetReverseFill(true)
	mainPCP:SetPoint("LEFT")
	mainPCP:SetPoint("RIGHT")
	mainPCP:SetPoint("TOP", power:GetStatusBarTexture(), "TOP")
	E:SmoothBar(mainPCP)
	mainPCP:SetHeight(128)

	local altPCP = CreateFrame("StatusBar", "$parentPowerCostPrediction", altMana)
	altPCP:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	altPCP:SetStatusBarColor(0.55, 0.75, 0.95)
	altPCP:SetOrientation("VERTICAL")
	altPCP:SetReverseFill(true)
	altPCP:SetPoint("LEFT")
	altPCP:SetPoint("RIGHT")
	altPCP:SetPoint("TOP", altMana:GetStatusBarTexture(), "TOP")
	E:SmoothBar(altPCP)
	altPCP:SetHeight(106)

	frame.PowerPrediction = {
		mainBar = mainPCP,
		altBar = altPCP
	}

	frame.PvP = UF:CreatePvPIcon(cover, "ARTWORK", 6, nil, true)
	frame.PvP:SetPoint("TOP", cover, "BOTTOM", 0, 12)
	frame:RegisterEvent("PLAYER_FLAGS_CHANGED", frame.PvP.Override)

	if C.units.player.castbar then
		frame.Castbar = UF:CreateCastBar(frame, 202, true, true)

		frame.Castbar.Holder:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 190)
		E:CreateMover(frame.Castbar.Holder)
	end

	local statusLeft = cover:CreateFontString("$parentLeftStatusIcons", "OVERLAY", "LSStatusIcon16Font")
	statusLeft:SetWidth(18)
	statusLeft:SetPoint("TOP", frame, "BOTTOM", -27, 2)
	frame:Tag(statusLeft, "[ls:leadericon][ls:lfdroleicon]")

	local statusRight = cover:CreateFontString("$parentRightStatusIcons", "OVERLAY", "LSStatusIcon16Font")
	statusRight:SetWidth(18)
	statusRight:SetPoint("TOP", frame, "BOTTOM", 27, 2)
	frame:Tag(statusRight, "[ls:combatresticon]")

	local debuffStatus = cover:CreateFontString("$parentDebuffStatus", "OVERLAY", "LSStatusIcon12Font")
	debuffStatus:SetWidth(14)
	debuffStatus:SetPoint("LEFT", health, "LEFT", 0, 0)
	frame:Tag(debuffStatus, "[ls:debuffstatus]")

	UF:Reskin(frame, 0, false)

	if E.PLAYER_CLASS == "MONK" then
		frame.Stagger = UF:CreateStaggerBar(frame, level + 4)
		frame.Stagger.Value:SetParent(cover)
		frame.Stagger.Value:SetPoint("CENTER", 0, -20)
		tinsert(frame.mouseovers, frame.Stagger)
	elseif E.PLAYER_CLASS == "DEATHKNIGHT" then
		frame.Runes = UF:CreateRuneBar(frame, level + 4)
	end

	frame.ClassIcons = UF:CreateClassPowerBar(frame, level + 4)

	local fcf = CreateFrame("Frame", "$parentFeedbackFrame", frame)
	fcf:SetFrameLevel(9)
	fcf:SetSize(32, 32)
	fcf:SetPoint("CENTER", 0, 0)
	frame.FloatingCombatFeedback = fcf

	for i = 1, 6 do
		fcf[i] = fcf:CreateFontString(nil, "OVERLAY", "CombatTextFont")
	end

	fcf.mode = "Fountain"
	fcf.xOffset = 15
	fcf.yOffset = 20
	fcf.abbreviateNumbers = true

	UF:CreateStatusHighlight(frame)
	UF:HandleTotems(frame)
end
