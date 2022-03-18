local _, ns = ...
local E, C, PrC, M, L, P, D, PrD = ns.E, ns.C, ns.PrC, ns.M, ns.L, ns.P, ns.D, ns.PrD

-- Lua
local _G = getfenv(0)
local ipairs = _G.ipairs
local loadstring = _G.loadstring
local next = _G.next
local pcall = _G.pcall
local s_format = _G.string.format
local s_rep = _G.string.rep
local t_insert = _G.table.insert
local t_sort = _G.table.sort
local tonumber = _G.tonumber
local tostring = _G.tostring
local type = _G.type

-- Mine
local LibDeflate = LibStub("LibDeflate")
local LibSerialize = LibStub("LibSerialize")

local function getProfileData(profileType)
	if not profileType or type(profileType) ~= "string" then
		return
	end

	local data = {}

	if profileType == "global-colors" then
		data.colors = {}

		E:CopyTable(C.db.global.colors, data.colors)

		data.colors.power[ 0] = nil
		data.colors.power[ 1] = nil
		data.colors.power[ 2] = nil
		data.colors.power[ 3] = nil
		data.colors.power[ 4] = nil
		data.colors.power[ 5] = nil
		data.colors.power[ 6] = nil
		data.colors.power[ 7] = nil
		data.colors.power[ 8] = nil
		data.colors.power[ 9] = nil
		data.colors.power[10] = nil
		data.colors.power[11] = nil
		data.colors.power[13] = nil
		data.colors.power[17] = nil
		data.colors.power[18] = nil

		E:DiffTable(D.global, data)
	elseif profileType == "global-tags" then
		data.tags = {}
		data.tag_vars = {}

		E:CopyTable(C.db.global.tags, data.tags)
		E:CopyTable(C.db.global.tag_vars, data.tag_vars)

		E:DiffTable(D.global, data)
	elseif profileType == "profile" then
		E.Movers:SaveConfig()

		E:CopyTable(C.db.profile, data)

		data.units.player = nil
		data.units.pet = nil
		data.version = nil

		E:DiffTable(D.profile, data)
	elseif profileType == "private" then
		E:CopyTable(PrC.db.profile, data)

		data.version = nil

		E:DiffTable(PrD.profile, data)
	end

	return data
end

local function keySort(a, b)
	local A, B = type(a), type(b)

	if A == B then
		if A == "number" or A == "string" then
			return a < b
		elseif A == "boolean" then
			return (a and 1 or 0) > (b and 1 or 0)
		end
	end

	return A < B
end

-- Credit goes to Mirrored (WeakAuras) and Simpy (ElvUI)
local function stringify(tbl, level, ret)
	local keys = {}
	for i in next, tbl do
		t_insert(keys, i)
	end
	t_sort(keys, keySort)

	for _, i in ipairs(keys) do
		local v = tbl[i]

		ret = ret .. s_rep('    ', level) .. '['

		if type(i) == "string" then
			ret = ret .. '"' .. i .. '"'
		else
			ret = ret .. i
		end

		ret = ret .. '] = '

		if type(v) == "number" then
			ret = ret .. v .. ',\n'
		elseif type(v) == "string" then
			ret = ret .. '"' .. v:gsub('\\', '\\\\'):gsub('\n', '\\n'):gsub('"', '\\"'):gsub('\124', '\124\124') .. '",\n'
		elseif type(v) == "boolean" then
			if v then
				ret = ret .. 'true,\n'
			else
				ret = ret .. 'false,\n'
			end
		elseif type(v) == "table" then
			ret = ret .. '{\n'
			ret = stringify(v, level + 1, ret)
			ret = ret .. s_rep('    ', level) .. '},\n'
		else
			ret = ret .. '"' .. tostring(v) .. '",\n'
		end
	end

	return ret
end

local function tableToString(tbl)
	return stringify(tbl, 1, "{\n") .. "}"
end

local function stringToTable(str)
	return pcall(loadstring("return " .. str:gsub("\124\124", "\124")))
end

E.Profiles = {}

function E.Profiles:Decode(data, dataFormat)
	if dataFormat == "string" then
		local decoded = LibDeflate:DecodeForPrint(data)
		if not decoded then return end

		local decompressed = LibDeflate:DecompressDeflate(decoded)
		if not decompressed then return end

		local isOK, rawData = LibSerialize:Deserialize(decompressed)
		if isOK then
			return rawData
		end
	elseif dataFormat == "table" then
		local isOK, rawData = stringToTable(data)
		if isOK then
			return rawData
		end
	end
end

function E.Profiles:Encode(data, dataFormat)
	if dataFormat == "string" then
		local serialized = LibSerialize:Serialize(data)
		local compressed = LibDeflate:CompressDeflate(serialized, {level = 9})

		return LibDeflate:EncodeForPrint(compressed)
	elseif dataFormat == "table" then
		return tableToString(data)
	end
end

function E.Profiles:Recode(data, newFormat)
	local version, profileType, curFormat, profileData = data:match("::lsui:(%d-):(%a-):(%a-):(.-)::")
	local header = s_format("::lsui:%s:%s:%s:", version, profileType, newFormat)

	profileData = self:Decode(profileData, curFormat)
	if not profileData then return end

	-- If we're here with the same format, then we might as well return the
	-- original data since it's not corrupted
	if curFormat == newFormat then
		return data
	end

	profileData = self:Encode(profileData, newFormat)

	return header .. profileData .. "::"
end

function E.Profiles:Export(profileType, exportFormat)
	local profileData = getProfileData(profileType)

	if profileType == "global-colors" or profileType == "global-tags" then
		profileType = "global"
	end

	local header = s_format("::lsui:%s:%s:%s:", E.VER.number, profileType, exportFormat)

	profileData = self:Encode(profileData, exportFormat)

	return header .. profileData .. "::"
end

function E.Profiles:Import(data, force)
	local version, profileType, importFormat, profileData = data:match("::lsui:(%d-):(%a-):(%a-):(.-)::")
	profileData = self:Decode(profileData, importFormat)

	if tonumber(version) < E.VER.number then
		-- TODO: update outdated data
	end

	print("|cffffd200importing", version, profileType, importFormat)
	if profileType == "profile" then
		-- TODO: if force is true, then overwrite the current profile
		-- TODO: otherwise create a new profile
		-- C.db:DeleteProfile("LSUI_TEMP_PROFILE", true)

		-- C.db.profiles["LSUI_TEMP_PROFILE"] = data

		-- C.db:CopyProfile("LSUI_TEMP_PROFILE")
		-- C.db:DeleteProfile("LSUI_TEMP_PROFILE")
	elseif profileType == "global" then
		-- TODO: add support for colours, tags, etc
		-- E:CopyTable(data.global, C.db.global)
	elseif profileType == "private" then
		-- TODO: if force is true, then overwrite the current profile
		-- TODO: otherwise create a new profile
		-- PrC.db:DeleteProfile("LSUI_TEMP_PROFILE", true)

		-- PrC.db.profiles["LSUI_TEMP_PROFILE"] = data

		-- PrC.db:CopyProfile("LSUI_TEMP_PROFILE")
		-- PrC.db:DeleteProfile("LSUI_TEMP_PROFILE")
	end

	return profileData
end
