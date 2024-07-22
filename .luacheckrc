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
	"211/Config",  -- Unused local variable Config
	"211/CONFIG",  -- Unused local variable CONFIG
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
	"AchievementMicroButton",
	"AddonCompartmentFrame",
	"AdiButtonAuras",
	"ADVENTURE_JOURNAL",
	"ATTACK_BUTTON_FLASH_TIME",
	"BagsBar",
	"BLIZZARD_STORE",
	"BreakUpLargeNumbers",
	"BuffFrame",
	"C_AddOns",
	"C_AdventureJournal",
	"C_AzeriteItem",
	"C_CurrencyInfo",
	"C_DelvesUI",
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
	"C_Spell",
	"C_Timer",
	"C_TooltipInfo",
	"C_UnitAuras",
	"C_WowTokenPublic",
	"CanExitVehicle",
	"CanInspect",
	"CHARACTER_BUTTON",
	"CharacterBackSlot",
	"CharacterBag0Slot",
	"CharacterBag1Slot",
	"CharacterBag2Slot",
	"CharacterBag3Slot",
	"CharacterChestSlot",
	"CharacterFeetSlot",
	"CharacterFinger0Slot",
	"CharacterFinger1Slot",
	"CharacterFrame",
	"CharacterHandsSlot",
	"CharacterHeadSlot",
	"CharacterLegsSlot",
	"CharacterMainHandSlot",
	"CharacterMicroButton",
	"CharacterModelScene",
	"CharacterNeckSlot",
	"CharacterReagentBag0Slot",
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
	"CollectionsMicroButton",
	"ColorMixin",
	"CooldownFrame_Set",
	"CreateFrame",
	"CreateUnsecuredObjectPool",
	"CreateVector2D",
	"DeadlyDebuffFrame",
	"DebuffFrame",
	"DeleteInboxItem",
	"DifficultyUtil",
	"DUNGEONS_BUTTON",
	"EJMicroButton",
	"ENCHANTED_TOOLTIP_LINE",
	"EncounterJournalSuggestFrame",
	"Enum",
	"ExpansionLandingPageMinimapButton",
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
	"FramerateFrame",
	"GameFontNormal",
	"GameTimeFrame",
	"GameTooltip",
	"GameTooltip_SetDefaultAnchor",
	"GameTooltipStatusBar",
	"GameTooltipTextLeft1",
	"GameTooltipTextLeft2",
	"GameTooltipTextRight1",
	"GameTooltipTooltip",
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
	"GetLFGDungeonShortageRewardInfo",
	"GetLFGRandomDungeonInfo",
	"GetLFGRoles",
	"GetLFGRoleShortageRewards",
	"GetLocale",
	"GetModifiedClick",
	"GetMoney",
	"GetMoneyString",
	"GetNetStats",
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
	"GetRealmName",
	"GetRFDungeonInfo",
	"GetSavedInstanceInfo",
	"GetSavedWorldBossInfo",
	"GetShapeshiftFormCooldown",
	"GetShapeshiftFormInfo",
	"GetSpecialization",
	"GetSpecializationInfo",
	"GetSpecializationInfoByID",
	"GetText",
	"GetTime",
	"GetTotemInfo",
	"GetValueOrCallFunction",
	"GetWeaponEnchantInfo",
	"GetXPExhaustion",
	"GUILD_AND_COMMUNITIES",
	"GuildMicroButton",
	"HELP_BUTTON",
	"HelpMicroButton",
	"HelpTip",
	"HideUIPanel",
	"HybridMinimap",
	"InboxFrame",
	"InCombatLockdown",
	"InGuildParty",
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
	"LE_REALM_RELATION_VIRTUAL",
	"LE_TOKEN_RESULT_ERROR_DISABLED",
	"LFDMicroButton",
	"LFG_ROLE_NUM_SHORTAGE_TYPES",
	"LibStub",
	"MailFrameInset",
	"MAINMENU_BUTTON",
	"MainMenuBar",
	"MainMenuBarBackpackButton",
	"MainMenuBarVehicleLeaveButton",
	"MainMenuMicroButton",
	"MainStatusTrackingBarContainer",
	"MAX_REPUTATION_REACTION",
	"MAX_TOTEMS",
	"MaxDps",
	"MicroButtonAndBagsBar",
	"MicroButtonTooltipText",
	"MicroMenu",
	"MicroMenuContainer",
	"Minimap",
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
	"NewPlayerExperience",
	"NineSliceUtil",
	"NotifyInspect",
	"OrderHallCommandBar",
	"oUF",
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
	"PLAYERSPELLS_BUTTON",
	"PlayerSpellsMicroButton",
	"PlaySound",
	"PossessActionBar",
	"ProfessionMicroButton",
	"PROFESSIONS_BUTTON",
	"PVPQueueFrame",
	"QUESTION_MARK_ICON",
	"QUESTLOG_BUTTON",
	"QuestLogMicroButton",
	"QueueStatusButton",
	"RANGE_INDICATOR",
	"RegisterAttributeDriver",
	"RegisterStateDriver",
	"ReloadUI",
	"ReputationFrame",
	"RequestLFDPartyLockInfo",
	"RequestLFDPlayerLockInfo",
	"RequestRaidInfo",
	"SaveBindings",
	"SecondaryStatusTrackingBarContainer",
	"SecondsToTime",
	"SecureHandlerSetFrameRef",
	"SetBinding",
	"SetCVar",
	"SetModifiedClick",
	"SetOverrideBindingClick",
	"Settings",
	"SettingsPanel",
	"SetWatchingHonorAsXP",
	"SpellFlyout",
	"StanceBar",
	"StatusTrackingBarManager",
	"StoreMicroButton",
	"TalkingHeadFrame",
	"TaxiRequestEarlyLanding",
	"TicketStatusFrame",
	"TimeManagerClockButton",
	"TimeManagerClockTicker",
	"TOOLTIP_UPDATE_TIME",
	"TooltipDataProcessor",
	"TotemFrame",
	"UIParent",
	"UnitBattlePetLevel",
	"UnitBattlePetType",
	"UnitClass",
	"UnitClassBase",
	"UnitClassification",
	"UnitCreatureType",
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
	"UnitTokenFromGUID",
	"UnitXP",
	"UnitXPMax",
	"UnregisterStateDriver",
	"UpdateAddOnMemoryUsage",
	"VehicleExit",
	"WOW_TOKEN_ITEM_ID",
	"ZoneAbilityFrame",
}
