local _, ns = ...
local E, C, M, L, P = ns.E, ns.C, ns.M, ns.L, ns.P
local MODULE = P:GetModule("Bars")

-- Lua
local _G = getfenv(0)
local next = _G.next

-- Mine
local isInit = false

local BUTTONS = {
	StanceButton1, StanceButton2, StanceButton3, StanceButton4, StanceButton5,
	StanceButton6, StanceButton7, StanceButton8, StanceButton9, StanceButton10,
}

local TOP_POINT = {
	p = "BOTTOM",
	anchor = "UIParent",
	rP = "BOTTOM",
	x = 0,
	y = 152,
}

local BOTTOM_POINT = {
	p = "BOTTOM",
	anchor = "UIParent",
	rP = "BOTTOM",
	x = 0,
	y = 124,
}

local LAYOUT = {
	WARRIOR = BOTTOM_POINT,
	PALADIN = BOTTOM_POINT,
	HUNTER = TOP_POINT,
	ROGUE = TOP_POINT,
	PRIEST = BOTTOM_POINT,
	DEATHKNIGHT = TOP_POINT,
	SHAMAN = TOP_POINT,
	MAGE = TOP_POINT,
	WARLOCK = TOP_POINT,
	MONK = BOTTOM_POINT,
	DRUID = BOTTOM_POINT,
	DEMONHUNTER = TOP_POINT,
}

local function getBarPoint()
	return LAYOUT[E.PLAYER_CLASS]
end

local function button_Update(self)
	if self:IsShown() then
		local id = self:GetID()
		local texture, _, isActive, isCastable = GetShapeshiftFormInfo(id)

		self.icon:SetTexture(texture)

		if texture then
			self.cooldown:Show()
		else
			self.cooldown:Hide()
		end

		self:SetChecked(isActive)

		if isCastable then
			self.icon:SetDesaturated(false)
			self.icon:SetVertexColor(M.COLORS.BUTTON_ICON.N:GetRGBA(1))
		else
			self.icon:SetDesaturated(true)
			self.icon:SetVertexColor(M.COLORS.BUTTON_ICON.N:GetRGBA(0.65))
		end

		self.HotKey:SetVertexColor(M.COLORS.BUTTON_ICON.N:GetRGB())

		self:UpdateHotKey()
		CooldownFrame_Set(self.cooldown, GetShapeshiftFormCooldown(id))
	end
end

local function button_UpdateHotKey(self, state)
	if state ~= nil then
		self._parent._config.hotkey = state
	end

	if self._parent._config.hotkey then
		self.HotKey:SetParent(self)
		self.HotKey:SetFormattedText("%s", self:GetBindingKey())
	else
		self.HotKey:SetParent(E.HIDDEN_PARENT)
	end
end

local function button_UpdateFontObjects(self)
	local config = self._parent._config.font
	self.HotKey:SetFontObject("LSFont"..config.size..(config.flag ~= "" and "_"..config.flag or ""))
end

function MODULE.CreateStanceBar()
	if not isInit then
		local bar = CreateFrame("Frame", "LSStanceBar", UIParent, "SecureHandlerStateTemplate")
		bar._id = "bar7"
		bar._buttons = {}

		MODULE:AddBar(bar._id, bar)

		bar.Update = function(self)
			self:UpdateConfig()
			self:UpdateFading()
			self:UpdateVisibility()
			self:UpdateButtons("Update")
			self:UpdateButtons("UpdateFontObjects")
			E:UpdateBarLayout(self)
		end
		bar.UpdateForms = function(self)
			local numStances = GetNumShapeshiftForms()

			for i, button in next, self._buttons do
				if i <= numStances then
					button:Show()
					button:Update()
				else
					button:Hide()
				end
			end
		end

		for i = 1, #BUTTONS do
			local button = CreateFrame("CheckButton", "$parentButton"..i, bar, "StanceButtonTemplate")
			button:SetID(i)
			button:SetScript("OnEvent", nil)
			button:SetScript("OnUpdate", nil)
			button:UnregisterAllEvents()
			button._parent = bar
			button._command = "SHAPESHIFTBUTTON"..i

			button.Update = button_Update
			button.UpdateFontObjects = button_UpdateFontObjects
			button.UpdateHotKey = button_UpdateHotKey

			BUTTONS[i]:SetAllPoints(button)
			BUTTONS[i]:SetAttribute("statehidden", true)
			BUTTONS[i]:SetParent(E.HIDDEN_PARENT)
			BUTTONS[i]:SetScript("OnEvent", nil)
			BUTTONS[i]:SetScript("OnUpdate", nil)
			BUTTONS[i]:UnregisterAllEvents()

			E:SkinStanceButton(button)

			bar._buttons[i] = button
		end

		bar:SetScript("OnEvent", function(self, event)
			if event == "UPDATE_SHAPESHIFT_COOLDOWN" then
				self:UpdateButtons("Update")
			elseif event == "PLAYER_REGEN_ENABLED" then
				if self.needsUpdate and not InCombatLockdown() then
					self.needsUpdate = nil
					self:UpdateForms()
				end
			else
				if InCombatLockdown() then
					self.needsUpdate = true
					self:UpdateButtons("Update")
				else
					self:UpdateForms()
				end
			end
		end)

		bar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
		bar:RegisterEvent("PLAYER_ENTERING_WORLD")
		bar:RegisterEvent("PLAYER_REGEN_ENABLED")
		bar:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
		bar:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR")
		bar:RegisterEvent("UPDATE_POSSESS_BAR")
		bar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
		bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		bar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
		bar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
		bar:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")

		local point = getBarPoint()
		bar:SetPoint(point.p, point.anchor, point.rP, point.x, point.y)
		E:CreateMover(bar)

		bar:Update()

		isInit = true
	end
end
