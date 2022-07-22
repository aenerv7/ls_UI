﻿-- Contributors: NicoCaine90@Curse, Terijaki@Curse, nicobertor@Curse

local _, ns = ...
local E, L = ns.E, ns.L

-- Lua
local _G = getfenv(0)

if GetLocale() ~= "deDE" then return end

L["ACTION_BARS"] = "Aktionsleisten"
L["ADDITIONAL_BAR"] = "Zusätzliche Leiste"
L["ADVENTURE_JOURNAL_DESC"] = "Zeige Infos zu Schlachtzugszuweisungen"
L["ALT_POWER_BAR"] = "Alternative Power-Leiste"
L["ALTERNATIVE_POWER"] = "Spezielle Ressourcen"
L["ALWAYS_SHOW"] = "Immer anzeigen"
L["ANCHOR"] = "Anheften an"
L["ANCHOR_TO_CURSOR"] = "An den Mauszeiger anheften"
L["ARTIFACT_LEVEL_TOOLTIP"] = "Artefaktlevel: |cffffffff%s|r"
L["ARTIFACT_POWER"] = "Artefaktmacht"
L["ASCENDING"] = "Aufsteigend"
L["AURA"] = "Aura"
L["AURA_FILTERS"] = "Aura Filter"
L["AURA_TRACKER"] = "Aura Anzeige"
L["AURA_TYPE"] = "Aura Typ"
L["AURAS"] = "Auren"
L["AUTO"] = "Automatisch"
L["BAG_SLOTS"] = "Taschenplätze"
L["BAR"] = "Leiste"
L["BAR_1"] = "Leiste 1"
L["BAR_2"] = "Leiste 2"
L["BAR_3"] = "Leiste 3"
L["BAR_4"] = "Leiste 4"
L["BAR_5"] = "Leiste 5"
L["BAR_COLOR"] = "Leistenfarbe"
L["BAR_TEXT"] = "Leistentext"
L["BLACKLIST"] = "Schwarze Liste"
L["BONUS_XP_TOOLTIP"] = "Bonus XP: |cffffffff%s|r"
L["BORDER"] = "Rahmen"
L["BORDER_COLOR"] = "Rahmenfarbe"
L["BOSS"] = "Boss"
L["BOSS_BUFFS"] = "Boss Buffs"
L["BOSS_BUFFS_DESC"] = "Zeige Buffs vom Boss."
L["BOSS_DEBUFFS"] = "Boss Debuffs"
L["BOSS_DEBUFFS_DESC"] = "Zeige Debuffs vom Boss."
L["BOSS_FRAMES"] = "Boss Portraits"
L["BOTTOM"] = "Unten"
L["BOTTOM_INSET_SIZE"] = "Untere Einpresstiefe"
L["BUFFS"] = "Stärkungszauber"
L["BUFFS_AND_DEBUFFS"] = "Stärkungs- und Schwächungszauber"
L["BUTTON"] = "Taste"
L["BUTTON_GRID"] = "Leiste immer anzeigen"
L["CALENDAR"] = "Kalender"
L["CAST_ON_KEY_DOWN"] = "Zaubern bei Tastendruck"
L["CASTABLE_BUFFS"] = "Wirkbare Stärkungszauber"
L["CASTABLE_BUFFS_DESC"] = "Zeigt eigene Stärkungszauber"
L["CASTABLE_BUFFS_PERMA"] = "Wirkbare dauerhafte Stärkungszauber"
L["CASTABLE_BUFFS_PERMA_DESC"] = "Zeigt dauerhaft eigene Stärkungszauber"
L["CASTABLE_DEBUFFS"] = "Wirkbare Schwächungszauber"
L["CASTABLE_DEBUFFS_DESC"] = "Zeigt eigene Schwächungszauber"
L["CASTABLE_DEBUFFS_PERMA"] = "Wirkbare dauerhafte Schwächungszauber"
L["CASTABLE_DEBUFFS_PERMA_DESC"] = "Zeigt dauerhaft eigene Schwächungszauber"
L["CASTBAR"] = "Zauberleiste"
L["CHARACTER_BUTTON_DESC"] = "Zeigt Haltbarkeitsinformation deiner Ausrüstung."
L["CLOCK"] = "Uhr"
L["COLORS"] = "Farben"
L["COOLDOWN"] = "Abklingzeiten"
L["COOLDOWN_TEXT"] = "Zahlen für Abklingkeiten"
L["COPY_FROM"] = "Kopieren von"
L["COPY_FROM_DESC"] = "Übernehme Einstellungen von diesem Ziel."
L["COST_PREDICTION"] = "Kostenvorraussage"
L["COUNT_TEXT"] = "Zähler Text"
L["CURSE"] = "Fluch"
L["DEAD"] = "Tot"
L["DEBUFFS"] = "Debuffs"
L["DIFFICULT"] = "Schwierig"
L["DIFFICULTY"] = "Schwierigkeit"
L["DIFFICULTY_FLAG"] = "Schwierigskeitsflagge"
L["DISABLE_MOUSE"] = "Maus deaktivieren"
L["DISABLE_MOUSE_DESC"] = "Ignoriere Mausklicks."
L["DISEASE"] = "Krankheit"
L["DOWN"] = "Runter"
L["EXPERIENCE"] = "Erfahrung"
L["FADING"] = "Ausblenden"
L["FLAG"] = "Flagge"
L["FOCUS_FRAME"] = "Fokusziel"
L["FOCUS_TOF"] = "Fokusziel und Ziel des Fokusziel"
L["FREE_BAG_SLOTS_TOOLTIP"] = "Freier Inventarplatz: |cffffffff%s|r"
L["HEALTH"] = "Lebenspunkte"
L["HONOR"] = "Ehre"
L["ICON"] = "Symbol"
L["LATENCY"] = "Latenz"
L["LATENCY_HOME"] = "Latenz Standort"
L["LATENCY_WORLD"] = "Latenz Welt"
L["LATER"] = "Später"
L["LEFT"] = "Links"
L["LEFT_DOWN"] = "Link und Runter"
L["LEFT_UP"] = "Link und Hoch"
L["LOCK"] = "Sperren"
L["LOCK_BUTTONS"] = "Sperre Knöpfe"
L["MODE"] = "Modus"
L["NAME"] = "Name"
L["NUMERIC"] = "Numerischer Wert"
L["NUMERIC_PERCENTAGE"] = "Numerischer Wert und Prozentsatz"
L["PET_BAR"] = "Begleiterleiste"
L["PET_BATTLE_BAR"] = "Haustierkampfleiste"
L["PET_CASTBAR"] = "Begleiter Zauberleiste"
L["PET_FRAME"] = "Begleiter"
L["PLAYER_FRAME"] = "Spieler"
L["POWER"] = "Ressource"
L["RUNES"] = "Runen"
L["STANCE_BAR"] = "Haltungsleiste"
L["STANDARD"] = "standardmäßig"
L["TARGET_FRAME"] = "Ziel"
L["TARGET_TOT"] = "Ziel und Ziel des Ziels"
L["THREAT_GLOW"] = "Bedrohungseffekt"
L["TIME"] = "Uhrzeit"
L["TOT_FRAME"] = "Ziel des Ziels"
L["TOTEMS"] = "Totems"
L["TRIVIAL"] = "Trivial"
L["UI_LAYOUT"] = "UI Oberfläche"
L["UNITS"] = "Einheiten"
L["UNUSABLE"] = "Nicht verwendbar"
L["USABLE"] = "Verwendbar"
L["VISIBILITY"] = "Sichtbarkeit"
L["XP_BAR"] = "Erfahrungsleiste"
