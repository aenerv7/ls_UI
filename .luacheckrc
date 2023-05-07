std = "none"
max_line_length = false
max_comment_line_length = 120
self = false

exclude_files = {
	".luacheckrc",
	"ls_UI/embeds/",
}

ignore = {
	"111/LS.*", -- Setting an undefined global variable starting with SLASH_
	"111/SLASH_.*", -- Setting an undefined global variable starting with SLASH_
	"112/LS.*", -- Mutating an undefined global variable starting with LS
	"112/ls_UI", -- Mutating an undefined global variable ls_UI
	"113/LS.*", -- Accessing an undefined global variable starting with LS
	"113/ls_UI", -- Accessing an undefined global variable ls_UI
	"122", -- Setting a read-only field of a global variable
	"211/_G", -- Unused local variable _G
	"211/C",  -- Unused local variable C
	"211/D",  -- Unused local variable D
	"211/E",  -- Unused local variable E
	"211/L",  -- Unused local variable L
	"211/M",  -- Unused local variable M
	"211/oUF",  -- Unused local variable oUF
	"211/P",  -- Unused local variable P
	"211/PrC",  -- Unused local variable C
	"211/PrD",  -- Unused local variable D
	"432", -- Shadowing an upvalue argument
}

globals = {
	-- Lua
	"getfenv",
	"print",

	-- AddOns
	"GetMinimapShape",

	-- FrameXML
	"SlashCmdList",
}

read_globals = {
	"ACHIEVEMENT_BUTTON",
	"AdiButtonAuras",
	"ADVENTURE_JOURNAL",
	"ArcheologyDigsiteProgressBar",
	"ATTACK_BUTTON_FLASH_TIME",
	"AutoCastShine_AutoCastStart",
	"AutoCastShine_AutoCastStop",
	"BACKPACK_TOOLTIP",
	"BagsBar",
	"BLIZZARD_STORE",
	"BreakUpLargeNumbers",
	"BuffFrame",
	"C_AddOns",
	"C_AzeriteItem",
	"C_CurrencyInfo",
	"C_GossipInfo",
	"C_Item",
	"C_Mail",
	"C_MajorFactions",
	"C_Map",
	"C_MountJournal",
	"C_PaperDollInfo",
	"C_PetBattles",
	"C_PetJournal",
	"C_PlayerInfo",
	"C_PvP",
	"C_QuestLog",
	"C_Reputation",
	"C_Timer",
	"C_TooltipInfo",
	"C_UnitAuras",
	"C_WowTokenPublic",
	"CanExitVehicle",
	"CanInspect",
	"CHARACTER_BUTTON",
	"CharacterBackSlot",
	"CharacterChestSlot",
	"CharacterFeetSlot",
	"CharacterFinger0Slot",
	"CharacterFinger1Slot",
	"CharacterFrame",
	"CharacterHandsSlot",
	"CharacterHeadSlot",
	"CharacterLegsSlot",
	"CharacterMainHandSlot",
	"CharacterModelScene",
	"CharacterNeckSlot",
	"CharacterSecondaryHandSlot",
	"CharacterShirtSlot",
	"CharacterShoulderSlot",
	"CharacterStatsPane",
	"CharacterTabardSlot",
	"CharacterTrinket0Slot",
	"CharacterTrinket1Slot",
	"CharacterWaistSlot",
	"CharacterWristSlot",
	"ClearOverrideBindings",
	"CLOSE",
	"COLLECTIONS",
	"ColorMixin",
	"CooldownFrame_Set",
	"CreateFrame",
	"CreateVector2D",
	"DeadlyDebuffFrame",
	"DebuffFrame",
	"DeleteInboxItem",
	"DUNGEONS_BUTTON",
	"ENCHANTED_TOOLTIP_LINE",
	"Enum",
	"ExtraAbilityContainer",
	"ExtraActionBarFrame",
	"ExtraActionButton1",
	"FACTION_STANDING_LABEL1",
	"FACTION_STANDING_LABEL2",
	"FACTION_STANDING_LABEL3",
	"FACTION_STANDING_LABEL4",
	"FACTION_STANDING_LABEL5",
	"FACTION_STANDING_LABEL6",
	"FACTION_STANDING_LABEL7",
	"FACTION_STANDING_LABEL8",
	"FauxScrollFrame_GetOffset",
	"FauxScrollFrame_OnVerticalScroll",
	"FauxScrollFrame_SetOffset",
	"FauxScrollFrame_Update",
	"FlowContainer_PauseUpdates",
	"GameFontNormal",
	"GameTimeFrame",
	"GameTooltip",
	"GameTooltip_SetDefaultAnchor",
	"GameTooltipStatusBar",
	"GameTooltipTextLeft1",
	"GameTooltipTextLeft2",
	"GameTooltipTextRight1",
	"GameTooltipTooltip",
	"GetAddOnInfo",
	"GetAddOnMemoryUsage",
	"GetAverageItemLevel",
	"GetBindingKey",
	"GetBindingText",
	"GetCurrentBindingSet",
	"GetCursorPosition",
	"GetCVarBool",
	"GetDifficultyInfo",
	"GetFlyoutInfo",
	"GetFrameHandleFrame",
	"GetGameTime",
	"GetGuildInfo",
	"GetInboxHeaderInfo",
	"GetInboxNumItems",
	"GetInspectSpecialization",
	"GetInstanceInfo",
	"GetInventoryItemDurability",
	"GetInventoryItemLink",
	"GetInventoryItemTexture",
	"GetItemCount",
	"GetItemInfo",
	"GetItemInfoInstant",
	"GetLFGDungeonShortageRewardInfo",
	"GetLFGRandomDungeonInfo",
	"GetLFGRoles",
	"GetLFGRoleShortageRewards",
	"GetLocale",
	"GetModifiedClick",
	"GetMoney",
	"GetMoneyString",
	"GetNetStats",
	"GetNumAddOns",
	"GetNumGroupMembers",
	"GetNumRandomDungeons",
	"GetNumRFDungeons",
	"GetNumSavedInstances",
	"GetNumSavedWorldBosses",
	"GetNumShapeshiftForms",
	"GetNumSubgroupMembers",
	"GetPetActionCooldown",
	"GetPetActionInfo",
	"GetPetActionSlotUsable",
	"GetQuestLogCompletionText",
	"GetQuestResetTime",
	"GetRFDungeonInfo",
	"GetSavedInstanceInfo",
	"GetSavedWorldBossInfo",
	"GetSelectedFaction",
	"GetShapeshiftFormCooldown",
	"GetShapeshiftFormInfo",
	"GetSpecialization",
	"GetSpecializationInfo",
	"GetSpecializationInfoByID",
	"GetSpellInfo",
	"GetSpellLink",
	"GetSpellSubtext",
	"GetText",
	"GetTime",
	"GetTotemInfo",
	"GetWatchedFactionInfo",
	"GetWeaponEnchantInfo",
	"GetXPExhaustion",
	"GetZonePVPInfo",
	"GUILD_AND_COMMUNITIES",
	"HELP_BUTTON",
	"HelpTip",
	"HideUIPanel",
	"HybridMinimap",
	"InboxFrame",
	"InCombatLockdown",
	"InGuildParty",
	"IsAddOnLoaded",
	"IsAltKeyDown",
	"IsControlKeyDown",
	"IsInActiveWorldPVP",
	"IsInGroup",
	"IsInRaid",
	"IsLFGDungeonJoinable",
	"IsPetAttackAction",
	"IsPlayerAtEffectiveMaxLevel",
	"IsPlayerSpell",
	"IsShiftKeyDown",
	"IsWatchingHonorAsXP",
	"IsXPUserDisabled",
	"ITEM_QUALITY_COLORS",
	"ItemRefTooltip",
	"KeybindFrames_InQuickKeybindMode",
	"Kiosk",
	"LE_REALM_RELATION_VIRTUAL",
	"LE_TOKEN_RESULT_ERROR_DISABLED",
	"LFG_ROLE_NUM_SHORTAGE_TYPES",
	"LibStub",
	"LoadAddOn",
	"MailFrameInset",
	"MAINMENU_BUTTON",
	"MainMenuBar",
	"MainMenuBarBackpackButton",
	"MainMenuBarVehicleLeaveButton",
	"MAX_REPUTATION_REACTION",
	"MAX_TOTEMS",
	"MaxDps",
	"MicroButtonAndBagsBar",
	"MicroButtonTooltipText",
	"MicroMenu",
	"Minimap",
	"MinimapButtonFrame",
	"MinimapCluster",
	"MinimapCompassTexture",
	"MinimapZoneText",
	"Mixin",
	"MultiBar5",
	"MultiBar6",
	"MultiBar7",
	"MultiBarBottomLeft",
	"MultiBarBottomRight",
	"MultiBarLeft",
	"MultiBarRight",
	"MultiCastActionBarFrame",
	"NEWBIE_TOOLTIP_LFGPARENT",
	"NewPlayerExperience",
	"NineSliceUtil",
	"NotifyInspect",
	"OrderHallCommandBar",
	"OverrideActionBar",
	"PanelTemplates_DisableTab",
	"PanelTemplates_EnableTab",
	"PanelTemplates_SetNumTabs",
	"PanelTemplates_SetTab",
	"PanelTemplates_TabResize",
	"PaperDollFrame",
	"PaperDollInnerBorderBottom",
	"PaperDollInnerBorderBottom2",
	"PaperDollInnerBorderBottomLeft",
	"PaperDollInnerBorderBottomRight",
	"PaperDollInnerBorderLeft",
	"PaperDollInnerBorderRight",
	"PaperDollInnerBorderTop",
	"PaperDollInnerBorderTopLeft",
	"PaperDollInnerBorderTopRight",
	"PetActionBar",
	"PetBattleFrame",
	"PetBattleFrameXPBar",
	"PetCastingBarFrame",
	"PetHasActionBar",
	"PlayerCastingBarFrame",
	"PlaySound",
	"PossessActionBar",
	"PVPQueueFrame",
	"QUESTLOG_BUTTON",
	"QueueStatusButton",
	"RANGE_INDICATOR",
	"RegisterAttributeDriver",
	"RegisterStateDriver",
	"ReloadUI",
	"RENOWN_LEVEL_LABEL",
	"ReputationDetailMainScreenCheckBox",
	"RequestLFDPartyLockInfo",
	"RequestLFDPlayerLockInfo",
	"RequestRaidInfo",
	"SaveBindings",
	"SecondsToTime",
	"SecureHandlerSetFrameRef",
	"SetBinding",
	"SetCVar",
	"SetModifiedClick",
	"SetOverrideBindingClick",
	"Settings",
	"SettingsPanel",
	"SetWatchedFactionIndex",
	"SetWatchingHonorAsXP",
	"SPELLBOOK_ABILITIES_BUTTON",
	"SpellFlyout",
	"StanceBar",
	"StatusTrackingBarManager",
	"TALENTS_BUTTON",
	"TalkingHeadFrame",
	"TaxiRequestEarlyLanding",
	"TicketStatusFrame",
	"TimeManagerClockButton",
	"TimeManagerClockTicker",
	"TOOLTIP_UPDATE_TIME",
	"TooltipDataProcessor",
	"TotemFrame",
	"UIParent",
	"UnitAura",
	"UnitBattlePetLevel",
	"UnitBattlePetType",
	"UnitBuff",
	"UnitClass",
	"UnitClassBase",
	"UnitClassification",
	"UnitCreatureType",
	"UnitDebuff",
	"UnitEffectiveLevel",
	"UnitExists",
	"UnitFactionGroup",
	"UnitGroupRolesAssigned",
	"UnitGUID",
	"UnitHasVehicleUI",
	"UnitHealth",
	"UnitHealthMax",
	"UnitHonor",
	"UnitHonorLevel",
	"UnitHonorMax",
	"UnitInParty",
	"UnitInRaid",
	"UnitIsAFK",
	"UnitIsBattlePetCompanion",
	"UnitIsConnected",
	"UnitIsDead",
	"UnitIsDND",
	"UnitIsFriend",
	"UnitIsGroupLeader",
	"UnitIsMercenary",
	"UnitIsPlayer",
	"UnitIsPVP",
	"UnitIsPVPFreeForAll",
	"UnitIsQuestBoss",
	"UnitIsTapDenied",
	"UnitIsUnit",
	"UnitIsWildBattlePet",
	"UnitLevel",
	"UnitName",
	"UnitOnTaxi",
	"UnitPhaseReason",
	"UnitPlayerControlled",
	"UnitPosition",
	"UnitPVPName",
	"UnitQuestTrivialLevelRange",
	"UnitRace",
	"UnitReaction",
	"UnitRealmRelationship",
	"UnitSelectionType",
	"UnitSex",
	"UnitThreatSituation",
	"UnitXP",
	"UnitXPMax",
	"UnregisterStateDriver",
	"UpdateAddOnMemoryUsage",
	"VehicleExit",
	"VehicleSeatIndicator",
	"WOW_TOKEN_ITEM_ID",
	"ZoneAbilityFrame",
}
