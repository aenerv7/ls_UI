local _, ns = ...
local E, C, M, L, P = ns.E, ns.C, ns.M, ns.L, ns.P
local UF = P:GetModule("UnitFrames")

-- Mine
local function element_PostUpdate(self, _, status)
	if status and status == 0 then
		self:SetVertexColor(M.COLORS.THREAT[1]:GetRGB())
		self:Show()
	end
end

local function frame_UpdateThreatIndicator(self)
	local config = self._config.threat
	local element = self.ThreatIndicator

	element.feedbackUnit = config.feedback_unit

	if config.enabled and not self:IsElementEnabled("ThreatIndicator") then
		self:EnableElement("ThreatIndicator")
	elseif not config.enabled and self:IsElementEnabled("ThreatIndicator") then
		self:DisableElement("ThreatIndicator")
	end

	if self:IsElementEnabled("ThreatIndicator") then
		element:ForceUpdate()
	end
end

function UF:CreateThreatIndicator(frame, parent, isTexture)
	local element

	if isTexture then
		element = (parent or frame):CreateTexture(nil, "BACKGROUND", nil, -7)
	else
		element = E:CreateBorder(parent or frame)
		element:SetTexture("Interface\\AddOns\\ls_UI\\assets\\border-thick-glow", "BACKGROUND", -7)
		element:SetSize(16)
		element:SetOffset(-6)
	end

	element.PostUpdate = element_PostUpdate

	frame.UpdateThreatIndicator = frame_UpdateThreatIndicator

	return element
end
