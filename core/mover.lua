local _, ns = ...
local E, C, PrC, M, L, P = ns.E, ns.C, ns.PrC, ns.M, ns.L, ns.P

-- Lua
local _G = getfenv(0)
local assert = _G.assert
local hooksecurefunc = _G.hooksecurefunc
local m_floor = _G.math.floor
local next = _G.next
local s_format = _G.string.format
local t_insert = _G.table.insert
local t_remove = _G.table.remove
local t_wipe = _G.table.wipe
local tostring = _G.tostring
local type = _G.type
local unpack = _G.unpack

-- Mine
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local TOOLTIP_ANCHORS = {
	["BOTTOM"] = {"ANCHOR_TOP", 0, 4},
	["BOTTOMLEFT"] = {"ANCHOR_RIGHT", 4, 4},
	["BOTTOMRIGHT"] = {"ANCHOR_LEFT", -4, 4},
	["LEFT"] = {"ANCHOR_BOTTOMRIGHT", 4, -4},
	["RIGHT"] = {"ANCHOR_BOTTOMLEFT", -4, -4},
	["TOP"] = {"ANCHOR_BOTTOM", 0, -4},
	["TOPLEFT"] = {"ANCHOR_BOTTOMRIGHT", 4, -4},
	["TOPRIGHT"] = {"ANCHOR_BOTTOMLEFT", -4, -4},
}

local linePool = {}
local activeLines = {}
local gridSize = 32

local grid = CreateFrame("Frame", nil, UIParent)
grid:SetFrameStrata("BACKGROUND")
grid:Hide()

local gridBG = grid:CreateTexture(nil, "BACKGROUND", nil, -7)
gridBG:SetAllPoints()
gridBG:SetColorTexture(0, 0, 0, 0.33)

local function getGridLine()
	if not next(linePool) then
		t_insert(linePool, grid:CreateTexture())
	end

	local line = t_remove(linePool, 1)
	line:ClearAllPoints()
	line:Show()

	t_insert(activeLines, line)

	return line
end

local function releaseGridLines()
	while next(activeLines) do
		local line = t_remove(activeLines, 1)
		line:ClearAllPoints()
		line:Hide()

		t_insert(linePool, line)
	end
end

local function hideGrid()
	grid:Hide()
end

local function drawGrid()
	releaseGridLines()

	local screenWidth, screenHeight = UIParent:GetRight(), UIParent:GetTop()
	local screenCenterX, screenCenterY = UIParent:GetCenter()

	grid:SetSize(screenWidth, screenHeight)
	grid:SetPoint("CENTER")
	grid:Show()

	local yAxis = getGridLine()
	yAxis:SetDrawLayer("BACKGROUND", 1)
	yAxis:SetColorTexture(0.9, 0.1, 0.1)
	yAxis:SetPoint("TOPLEFT", grid, "TOPLEFT", screenCenterX - 1, 0)
	yAxis:SetPoint("BOTTOMRIGHT", grid, "BOTTOMLEFT", screenCenterX + 1, 0)

	local xAxis = getGridLine()
	xAxis:SetDrawLayer("BACKGROUND", 1)
	xAxis:SetColorTexture(0.9, 0.1, 0.1)
	xAxis:SetPoint("TOPLEFT", grid, "BOTTOMLEFT", 0, screenCenterY + 1)
	xAxis:SetPoint("BOTTOMRIGHT", grid, "BOTTOMRIGHT", 0, screenCenterY - 1)

	local l = getGridLine()
	l:SetDrawLayer("BACKGROUND", 2)
	l:SetColorTexture(0.8, 0.8, 0.1)
	l:SetPoint("TOPLEFT", grid, "TOPLEFT", screenWidth / 3 - 1, 0)
	l:SetPoint("BOTTOMRIGHT", grid, "BOTTOMLEFT", screenWidth / 3 + 1, 0)

	local r = getGridLine()
	r:SetDrawLayer("BACKGROUND", 2)
	r:SetColorTexture(0.8, 0.8, 0.1)
	r:SetPoint("TOPRIGHT", grid, "TOPRIGHT", - screenWidth / 3 + 1, 0)
	r:SetPoint("BOTTOMLEFT", grid, "BOTTOMRIGHT", - screenWidth / 3 - 1, 0)

	-- horiz lines
	local tex
	for i = 1, m_floor(screenHeight / 2 / gridSize) do
		tex = getGridLine()
		tex:SetDrawLayer("BACKGROUND", 0)
		tex:SetColorTexture(0, 0, 0)
		tex:SetPoint("TOPLEFT", grid, "BOTTOMLEFT", 0, screenCenterY + 1 + gridSize * i)
		tex:SetPoint("BOTTOMRIGHT", grid, "BOTTOMRIGHT", 0, screenCenterY - 1 + gridSize * i)

		tex = getGridLine()
		tex:SetDrawLayer("BACKGROUND", 0)
		tex:SetColorTexture(0, 0, 0)
		tex:SetPoint("BOTTOMLEFT", grid, "BOTTOMLEFT", 0, screenCenterY - 1 - gridSize * i)
		tex:SetPoint("TOPRIGHT", grid, "BOTTOMRIGHT", 0, screenCenterY + 1 - gridSize * i)
	end

	-- vert lines
	for i = 1, m_floor(screenWidth / 2 / gridSize) do
		tex = getGridLine()
		tex:SetDrawLayer("BACKGROUND", 0)
		tex:SetColorTexture(0, 0, 0)
		tex:SetPoint("TOPLEFT", grid, "TOPLEFT", screenCenterX - 1 - gridSize * i, 0)
		tex:SetPoint("BOTTOMRIGHT", grid, "BOTTOMLEFT", screenCenterX + 1 - gridSize * i, 0)

		tex = getGridLine()
		tex:SetDrawLayer("BACKGROUND", 0)
		tex:SetColorTexture(0, 0, 0)
		tex:SetPoint("TOPRIGHT", grid, "TOPLEFT", screenCenterX + 1 + gridSize * i, 0)
		tex:SetPoint("BOTTOMLEFT", grid, "BOTTOMLEFT", screenCenterX - 1 + gridSize * i, 0)
	end
end

local defaultPoints = {}
local currentPoints = {}
local disabledMovers = {}
local enabledMovers = {}
local trackedMovers = {}
local highlightIndex = 0
local isDragging = false
local areToggledOn = false
local showLabels = false

local controller = CreateFrame("Frame", "LSMoverTracker", UIParent)
controller:SetPoint("TOPLEFT", 0, 0)
controller:SetSize(1, 1)
controller:SetScript("OnKeyDown", function(self, key)
	if self.mover then
		self:SetPropagateKeyboardInput(false)
		if key == "LEFT" then
			self.mover:UpdatePosition(-1, 0)
		elseif key == "RIGHT" then
			self.mover:UpdatePosition(1, 0)
		elseif key == "UP" then
			self.mover:UpdatePosition(0, 1)
		elseif key == "DOWN" then
			self.mover:UpdatePosition(0, -1)
		else
			self:SetPropagateKeyboardInput(true)
		end
	else
		self:SetPropagateKeyboardInput(true)
	end
end)
controller:SetScript("OnUpdate", function(self, elapsed)
	if not isDragging then
		local isAltKeyDown = IsAltKeyDown()
		if isAltKeyDown ~= self.isAltKeyDown then
			if isAltKeyDown and #trackedMovers > 0 then
				highlightIndex = highlightIndex + 1
			end

			self.isAltKeyDown = isAltKeyDown
		end

		self.elapsed = (self.elapsed or 0) + elapsed

		if self.elapsed > 0.1 then
			t_wipe(trackedMovers)

			for _, mover in next, enabledMovers do
				if not mover.isSimple then
					if mover:IsMouseOver(4, -4, -4, 4) then
						t_insert(trackedMovers, mover)
					end

					mover:EnableMouse(true)
				end
			end

			if #trackedMovers > 0 then
				if highlightIndex > #trackedMovers or #trackedMovers == 1 then
					highlightIndex = 1
				end

				for i = 1, #trackedMovers do
					if i == highlightIndex then
						local mover = trackedMovers[highlightIndex]
						if mover ~= self.mover then
							mover:Raise()
							mover:GetScript("OnEnter")(mover)

							self.mover = mover
						end
					else
						trackedMovers[i]:EnableMouse(false)
					end
				end

				for _, mover in next, enabledMovers do
					if not mover.isSimple then
						if mover == self.mover then
							E:FadeIn(mover, 0.15, 0.5)
						else
							E:FadeOut(mover, 0, 0.15, 0.5)
						end
					end
				end
			else
				self.mover = nil

				for _, mover in next, enabledMovers do
					if not mover.isSimple then
						E:FadeIn(mover, 0.15, 0.5)
					end
				end
			end

			self.elapsed = 0
		end
	else
		self.elapsed = 0
	end
end)
controller:Hide()

local settings
do
	settings = CreateFrame("Frame", "LSMoverSettings", UIParent)
	settings:SetSize(320, 160)
	settings:SetPoint("CENTER")
	settings:SetMovable(true)
	settings:EnableMouse(true)
	settings:RegisterForDrag("LeftButton")
	settings:SetClampedToScreen(true)
	settings:SetScript("OnDragStart", settings.StartMoving)
	settings:SetScript("OnDragStop", settings.StopMovingOrSizing)
	settings:SetScript("OnShow", function(self)
		self.NameToggle.Text:SetText(L["MOVER_NAMES"])
		self.GridDropdown:SetText(L["MOVER_GRID"])
		self.UsageText:SetText(L["MOVER_MOVE_DESC"] .. "\n\n" .. L["MOVER_RESET_DESC"] .. "\n\n" .. L["MOVER_CYCLE_DESC"])
		self.LockButton.Text:SetText(L["LOCK"])
	end)
	settings:Hide()

	local bg = settings:CreateTexture(nil, "BACKGROUND", nil, -7)
	bg:SetAllPoints()
	bg:SetTexture("Interface\\HELPFRAME\\DarkSandstone-Tile", "REPEAT", "REPEAT")
	bg:SetHorizTile(true)
	bg:SetVertTile(true)

	local border = E:CreateBorder(settings)
	border:SetTexture("Interface\\AddOns\\ls_UI\\assets\\border-thick")
	settings.Border = border

	local nameToggle = CreateFrame("CheckButton", "$parentNameToggle", settings, "OptionsCheckButtonTemplate")
	nameToggle:SetPoint("TOPLEFT", 1, 0)
	nameToggle:SetScript("OnClick", function()
		showLabels = not showLabels

		for _, mover in next, enabledMovers do
			if not mover.isSimple then
				mover.Text:SetShown(showLabels)
			end
		end
	end)
	settings.NameToggle = nameToggle

	nameToggle.Text = _G[nameToggle:GetName() .. "Text"]

	local gridDropdown = LibStub("LibDropDown"):NewButtonStretch(settings, "$parentGridDropdown")
	gridDropdown:SetPoint("TOPRIGHT", -3, -3)
	gridDropdown:SetSize(120, 20)
	gridDropdown:SetFrameLevel(3)
	gridDropdown:SetText(L["MOVER_GRID"])
	settings.GridDropdown = gridDropdown

	local info = {
		isRadio = true,
		func = function(_, _, value)
			gridSize = value

			drawGrid()
		end,
		checked = function(self)
			return gridSize == self.args[1]
		end,
	}

	local GRID_SIZES = {4, 8, 16, 32}
	for i = 1, #GRID_SIZES do
		info.text = tostring(GRID_SIZES[i])
		info.args = {GRID_SIZES[i]}

		gridDropdown:Add(info)
	end

	local usageText = settings:CreateFontString(nil, "OVERLAY")
	usageText:SetFontObject("GameFontNormal")
	usageText:SetPoint("TOPLEFT", 4, -24)
	usageText:SetPoint("BOTTOMRIGHT", -4, 26)
	usageText:SetJustifyH("LEFT")
	usageText:SetJustifyV("MIDDLE")
	settings.UsageText = usageText

	local lockButton = CreateFrame("Button", "$parentLockButton", settings, "UIPanelButtonTemplate")
	lockButton:SetHeight(21)
	lockButton:SetPoint("LEFT", 2, 0)
	lockButton:SetPoint("RIGHT", -2, 0)
	lockButton:SetPoint("BOTTOM", 0, 3)
	lockButton:SetScript("OnClick", function()
		E.Movers:ToggleAll()
	end)
	settings.LockButton = lockButton
end

local function getPoint(self)
	local p, anchor, rP, x, y = self:GetPoint()
	if not x then
		return p, anchor, rP, x, y
	else
		return p, anchor and anchor:GetName() or "UIParent", rP, E:Round(x), E:Round(y)
	end
end

local function calculatePosition(self)
	local moverCenterX, moverCenterY = self:GetCenter()
	local parent = self:GetHive() and self:GetHive():GetObject() or UIParent
	local p, rP, x, y

	if moverCenterX and moverCenterY then
		local parentWidth = parent:GetWidth()
		local parentCenterX, parentCenterY = parent:GetCenter()
		local parentLeftX = parentCenterX - parentWidth / 3
		local parentRightX = parentCenterX + parentWidth / 3

		if moverCenterY >= parentCenterY then
			if self:GetBottom() >= parent:GetTop() then
				p = "BOTTOM"
				rP = "TOP"
				y = self:GetBottom() - parent:GetTop()
			else
				p = "TOP"
				rP = "TOP"
				y = self:GetTop() - parent:GetTop()
			end
		else
			if self:GetTop() <= parent:GetBottom() then
				p = "TOP"
				rP = "BOTTOM"
				y = self:GetTop() - parent:GetBottom()
			else
				p = "BOTTOM"
				rP = "BOTTOM"
				y = self:GetBottom() - parent:GetBottom()
			end
		end

		if moverCenterX >= parentRightX then
			if self:GetLeft() >= parent:GetRight() then
				p = p .. "LEFT"
				rP = rP .. "RIGHT"
				x = self:GetLeft() - parent:GetRight()
			else
				p = p .. "RIGHT"
				rP = rP .. "RIGHT"
				x = self:GetRight() - parent:GetRight()
			end
		elseif moverCenterX <= parentLeftX then
			if self:GetRight() <= parent:GetLeft() then
				p = p .. "RIGHT"
				rP = rP .. "LEFT"
				x = self:GetRight() - parent:GetLeft()
			else
				p = p .. "LEFT"
				rP = rP .. "LEFT"
				x = self:GetLeft() - parent:GetLeft()
			end
		else
			x = moverCenterX - parentCenterX
		end
	end

	return p, parent:GetName(), rP, E:Round(x), E:Round(y)
end

local function updatePosition(self, p, anchor, rP, x, y, xOffset, yOffset)
	if not x then
		if currentPoints[self:GetName()] then
			p, anchor, rP, x, y = unpack(currentPoints[self:GetName()])
			anchor = anchor or "UIParent"
		end

		if not x then
			self:ResetPosition()
			return
		end
	end

	x = x + (xOffset or 0)
	y = y + (yOffset or 0)

	-- jic we got out of screen bounds because of offsets
	-- I could probably group them up better, but whatevs
	if anchor == "UIParent" then
		local l, r, t, b = self:GetClampRectInsets()
		l, r, t, b = E:Round(-l), E:Round(-r), E:Round(-t), E:Round(-b)

		if p == "BOTTOM" then
			if y < b then
				y = b
			end
		elseif p == "BOTTOMLEFT" then
			if x < l then
				x = l
			end

			if y < b then
				y = b
			end
		elseif p == "BOTTOMRIGHT" then
			if x > r then
				x = r
			end

			if y < b then
				y = b
			end
		elseif p == "TOP" then
			if y > t then
				y = t
			end
		elseif p == "TOPLEFT" then
			if x < l then
				x = l
			end

			if y > t then
				y = t
			end
		elseif p == "TOPRIGHT" then
			if x > r then
				x = r
			end

			if y > t then
				y = t
			end
		end
	end

	self:ClearAllPoints()
	self:SetPoint(p, anchor, rP, x, y)

	return p, anchor, rP, x, y
end

local function resetObjectPoint(self, _, _, _, _, _, shouldIgnore)
	local mover = self:GetMover()
	if mover and not shouldIgnore then
		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", mover, "TOPRIGHT", -mover.offsetX, -mover.offsetY, true)
	end
end

local mover_proto = {
	PostSaveUpdatePosition = E.NOOP,
}

function mover_proto:SavePosition(p, anchor, rP, x, y)
	currentPoints[self:GetName()] = {p, anchor, rP, x, y}
end

function mover_proto:ResetPosition()
	if not self.isSimple and InCombatLockdown() then return end

	local p, anchor, rP, x, y = unpack(defaultPoints[self:GetName()])

	self:ClearAllPoints()
	self:SetPoint(p, anchor, rP, x, y)
	self:SavePosition(p, anchor, rP, x, y)

	if not self.isSimple then
		self.Bg:SetColorTexture(E:GetRGBA(C.db.global.colors.black, 0.6))
	end

	self:PostSaveUpdatePosition()
end

function mover_proto:UpdatePosition(xOffset, yOffset)
	if not self.isSimple and InCombatLockdown() then return end

	local p, anchor, rP, x, y = calculatePosition(self)
	p, anchor, rP, x, y = updatePosition(self, p, anchor, rP, x, y, xOffset, yOffset)

	self:SavePosition(p, anchor, rP, x, y)

	if self.isSimple then
		self:Show()
	else
		if self:WasMoved() then
			self.Bg:SetColorTexture(E:GetRGBA(C.db.global.colors.orange, 0.6))
		else
			self.Bg:SetColorTexture(E:GetRGBA(C.db.global.colors.black, 0.6))
		end
	end

	self:PostSaveUpdatePosition()
end

function mover_proto:OnEnter()
	if not self:GetScript("OnUpdate") then
		self:SetScript("OnUpdate", self.OnUpdate)
	end

	local p, anchor, rP, x, y = calculatePosition(self)

	GameTooltip:SetOwner(self, unpack(TOOLTIP_ANCHORS[p]))
	GameTooltip:AddLine(self:GetName())
	GameTooltip:AddLine("|cffffd100Point:|r " .. p, 1, 1, 1)
	GameTooltip:AddLine("|cffffd100Attached to:|r " .. rP .. " |cffffd100of|r " .. anchor, 1, 1, 1)
	GameTooltip:AddLine("|cffffd100X:|r " .. x .. ", |cffffd100Y:|r " .. y, 1, 1, 1)
	GameTooltip:Show()
end

function mover_proto:OnLeave()
	self:SetScript("OnUpdate", nil)

	GameTooltip:Hide()
end

function mover_proto:OnUpdate(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed

	if self.elapsed > 0.1 then
		if GameTooltip:IsOwned(self) then
			if self:IsMouseOver() then
				self:OnEnter()
			else
				self:OnLeave()
			end
		end

		self.elapsed = 0
	end
end

function mover_proto:OnDragStart()
	if not self.isSimple and InCombatLockdown() then return end

	if self:IsDragKeyDown() then
		self:StartMoving()

		isDragging = true
	end
end

function mover_proto:OnDragStop()
	if not self.isSimple and InCombatLockdown() then return end

	self:StopMovingOrSizing()
	self:UpdatePosition()

	isDragging = false
end

function mover_proto:OnClick()
	if IsShiftKeyDown() then
		self:ResetPosition()

		if GameTooltip:IsOwned(self) then
			self:OnEnter()
		end
	end
end

function mover_proto:OnMouseWheel(offset)
	if IsShiftKeyDown() then
		self:UpdatePosition(0, offset)
	elseif IsControlKeyDown() then
		self:UpdatePosition(offset, 0)
	end

	if GameTooltip:IsOwned(self) then
		self:OnEnter()
	end
end

function mover_proto:IsEnabled()
	return not not enabledMovers[self:GetName()]
end

-- it's here for other things to override
function mover_proto:IsDragKeyDown()
	return true
end

function mover_proto:WasMoved()
	return not E:IsEqualTable(defaultPoints[self:GetName()], currentPoints[self:GetName()])
end

function mover_proto:GetDrones()
	return self.drones
end

function mover_proto:AddDrone(drone)
	drone.hive = self
	self.drones[drone] = true
end

function mover_proto:RemoveDrone(drone)
	drone.hive = nil
	self.drones[drone] = nil
end

function mover_proto:GetHive()
	return self.hive
end

function mover_proto:AddToHive(hive)
	self:RemoveFromHive()
	hive:AddDrone(self)
end

function mover_proto:RemoveFromHive()
	local hive = self:GetHive()
	if hive then
		hive:RemoveDrone(self)
	end
end

function mover_proto:Enable()
	local name = self:GetName()

	if enabledMovers[name] or not disabledMovers[name] then return end

	enabledMovers[name] = disabledMovers[name]
	disabledMovers[name] = nil

	enabledMovers[name]:UpdatePosition()
	resetObjectPoint(self.object)

	if areToggledOn then
		enabledMovers[name]:Show()
	end
end

function mover_proto:Disable()
	local name = self:GetName()

	if disabledMovers[name] or not enabledMovers[name] then return end

	enabledMovers[name]:Hide()

	disabledMovers[name] = enabledMovers[name]
	enabledMovers[name] = nil
end

function mover_proto:UpdateSize(width, height)
	self:SetWidth(width or (self.object:GetWidth() + self.offsetX * 2))
	self:SetHeight(height or (self.object:GetHeight() + self.offsetY * 2))
end

function mover_proto:GetObject()
	return self.object
end

local object_proto = {}

function object_proto:GetMover(inclDisabled)
	local name = self:GetName()
	name = name .. "Mover"

	if inclDisabled and disabledMovers[name] then
		return disabledMovers[name], true
	end

	return enabledMovers[name], false
end

E.Movers = {}

function E.Movers:Create(object, isSimple, offsetX, offsetY)
	if not object then return end

	local objectName = object:GetName()

	assert(objectName, (s_format("Failed to create a mover, object '%s' has no name", object:GetDebugName())))

	Mixin(object, object_proto)

	local name = objectName .. "Mover"
	local info = {
		object = object,
		isSimple = isSimple,
		offsetX = offsetX or 0,
		offsetY = offsetY or 0,
		-- hive = nil,
		drones = {},
	}

	local mover = Mixin(CreateFrame("Button", name, UIParent), mover_proto, info)
	mover:SetFrameLevel(object:GetFrameLevel() + 4)
	mover:SetWidth(object:GetWidth() + mover.offsetX * 2)
	mover:SetHeight(object:GetHeight() + mover.offsetX * 2)
	mover:SetClampedToScreen(true)
	mover:SetClampRectInsets(-4, 4, 4, -4)
	mover:SetMovable(true)
	mover:SetToplevel(true)
	mover:RegisterForDrag("LeftButton")
	mover:SetScript("OnDragStart", mover.OnDragStart)
	mover:SetScript("OnDragStop", mover.OnDragStop)

	if not isSimple then
		mover:SetScript("OnClick", mover.OnClick)
		mover:SetScript("OnEnter", mover.OnEnter)
		mover:SetScript("OnLeave", mover.OnLeave)
		mover:SetScript("OnMouseWheel", mover.OnMouseWheel)
		mover:SetShown(areToggledOn)

		local bg = mover:CreateTexture(nil, "BACKGROUND", nil, 0)
		bg:SetColorTexture(E:GetRGBA(C.db.global.colors.black, 0.6))
		bg:SetAllPoints()
		mover.Bg = bg

		local text = mover:CreateFontString(nil, "OVERLAY")
		text:SetFontObject("GameFontNormalOutline")
		text:SetPoint("CENTER")
		text:SetText(name)
		text:SetShown(showLabels)
		mover.Text = text

		local border = E:CreateBorder(mover)
		border:SetTexture({1, 1, 1, 1})
		border:SetVertexColor(E:GetRGB(C.db.global.colors.class[E.PLAYER_CLASS]))
		border:SetSize(1)
		border:SetOffset(0)
		mover.Border = border
	end

	-- * db conversion, changed in 90200.02
	if C.db.profile.movers[E.UI_LAYOUT][name] and C.db.profile.movers[E.UI_LAYOUT][name].point then
		C.db.profile.movers[E.UI_LAYOUT][name] = {unpack(C.db.profile.movers[E.UI_LAYOUT][name].point)}
	end

	defaultPoints[name] = {getPoint(object)}

	currentPoints[name] = {getPoint(object)}

	if C.db.profile.movers[E.UI_LAYOUT][name] then
		E:CopyTable(C.db.profile.movers[E.UI_LAYOUT][name], currentPoints[name])
	end

	local parentName = currentPoints[name][2]
	if parentName and parentName ~= "UIParent" then
		local hive = enabledMovers[parentName .. "Mover"]
		if hive then
			-- print(mover:GetDebugName(), "|cff00ff00==>|r", parentName)
			mover:AddToHive(hive)
			mover:UpdatePosition()
		else
			-- print(mover:GetDebugName(), "|cffff0000==>|r", parentName)
		end
	else
		-- print(mover:GetDebugName(), "|cffffd200==>|r", parentName)
		mover:UpdatePosition()
	end

	enabledMovers[name] = mover

	hooksecurefunc(object, "SetPoint", resetObjectPoint)
	resetObjectPoint(object)

	return mover
end

function E.Movers:Get(object, inclDisabled)
	if type(object) == "table" then
		object = object:GetName()
	end

	if not object then return end

	if inclDisabled and disabledMovers[object .. "Mover"] then
		return disabledMovers[object .. "Mover"], true
	end

	return enabledMovers[object .. "Mover"], false
end

local reopenConfig

function E.Movers:ToggleAll(...)
	if InCombatLockdown() then return end
	areToggledOn = not areToggledOn

	for _, mover in next, enabledMovers do
		if not mover.isSimple then
			mover:SetShown(areToggledOn)
		end
	end

	if areToggledOn then
		reopenConfig = ...

		drawGrid()

		settings:Show()
		controller:Show()
	else
		hideGrid()

		settings:Hide()
		controller:Hide()

		if reopenConfig then
			if AceConfigDialog then
				AceConfigDialog:Open("ls_UI")
			end
		end
	end
end

function E.Movers:UpdateAll()
	for _, mover in next, enabledMovers do
		updatePosition(mover, nil, "UIParent")

		if mover.isSimple then
			mover:Show()
		else
			if mover:WasMoved() then
				mover.Bg:SetColorTexture(E:GetRGBA(C.db.global.colors.orange, 0.6))
			else
				mover.Bg:SetColorTexture(E:GetRGBA(C.db.global.colors.black, 0.6))
			end
		end
	end
end

function E.Movers:SaveConfig()
	E:DiffTable(defaultPoints, E:CopyTable(currentPoints, C.db.profile.movers[E.UI_LAYOUT]))
end

P:AddCommand("movers", function()
	E.Movers:ToggleAll()
end)

E:RegisterEvent("PLAYER_REGEN_DISABLED", function()
	for _, mover in next, enabledMovers do
		if not mover.isSimple then
			if mover:IsMouseEnabled() then
				mover:OnDragStop()
			end

			mover:Hide()
		end
	end

	controller:Hide()

	hideGrid()
end)
