local ADDON_NAME, private = ...

local L = private:NewLocale("deDE")
if not L then return end

L.SlashAnchor = "anchor"
L.SlashAnchorText = "Toggle Frame Anchors"
L.SlashAnchorOn = "xanDebuffTimers: Anchors now [|cFF99CC33SHOWN|r]"
L.SlashAnchorOff = "xanDebuffTimers: Anchors now [|cFF99CC33HIDDEN|r]"
L.SlashAnchorInfo = "Toggles movable anchors."

L.SlashReset = "reset"
L.SlashResetText = "Reset Anchor Positions"
L.SlashResetInfo = "Reset anchor positions."

L.Reset = "Zurücksetzen"

L.SlashScale = "scale"
L.SlashScaleSet = "xanDebuffTimers: scale has been set to [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "Scale invalid! Number must be from [0.5 - 5].  (0.5, 1, 3, 4.6, etc..)"
L.SlashScaleInfo = "Set the scale of the LootRollMover loot frames (0.5 - 5)."
L.SlashScaleText = "xanDebuffTimers Bar Scale"

L.SlashGrow = "grow"
L.SlashGrowUp = "xanDebuffTimers: Bars will now grow [|cFF99CC33UP|r]"
L.SlashGrowDown = "xanDebuffTimers: Bars will now grow [|cFF99CC33DOWN|r]"
L.SlashGrowInfo = "Toggle the direction in which the bars grow (|cFF99CC33UP/DOWN|r)."
L.SlashGrowChkBtn = "Bars will grow [|cFF99CC33DOWN|r]."

L.SlashSort = "sort"
L.SlashSortDescending = "xanDebuffTimers: Bars will now sort [|cFF99CC33DESCENDING|r]"
L.SlashSortAscending = "xanDebuffTimers: Bars will now sort [|cFF99CC33ASCENDING|r]"
L.SlashSortInfo = "Toggle the sorting of the bars. (|cFF99CC33ASCENDING/DESCENDING|r)."
L.SlashSortChkBtn = "Bars will sort [|cFF99CC33ASCENDING|r]."

L.SlashReload = "reload"
L.SlashReloadText = "Reload Debuff Bars"
L.SlashReloadInfo = "Reload debuff bars."
L.SlashReloadAlert = "xanDebuffTimers: Debuff bars reloaded!"

L.SlashInfinite = "infinite"
L.SlashInfiniteOn = "xanDebuffTimers: Show debuffs whom have no durations/timers or are infinite. [|cFF99CC33ON|r]"
L.SlashInfiniteOff = "xanDebuffTimers: Show debuffs whom have no durations/timers or are infinite. [|cFF99CC33OFF|r]"
L.SlashInfiniteInfo = "Toggle debuffs whom have no durations/timers or are infinite. (|cFF99CC33ON/OFF|r)."
L.SlashInfiniteChkBtn = "Show debuffs whom have no durations/timers or are infinite. [|cFF99CC33ON|r]."

L.TimeHour = "h"
L.TimeMinute = "m"
L.TimeSecond = "s"

L.BarTargetAnchor = "xanDebuffTimers: Target Anchor"
L.BarFocusAnchor = "xanDebuffTimers: Focus Anchor"

L.IconChkBtn = "Show debuff icons. [|cFF99CC33ON|r]."
L.SpellNameChkBtn = "Show debuff spell names. [|cFF99CC33ON|r]."
L.HideInRested = "Hide Debuff Bars when in a Rested Area."
L.ShowTimerOnRight = "Show the timer on the right of debuff icon."

L.GraphicBarChkBtn = "Grafische Debuffbalken verwenden."
L.BarColorText = "Debuffbalken-Farbe."

L.NoTimerBarsOn = "xanDebuffTimers: Graue \226\136\158-Leisten bei nicht verfügbaren Timerdaten anzeigen. [|cFF99CC33AN|r]"
L.NoTimerBarsOff = "xanDebuffTimers: Graue \226\136\158-Leisten bei nicht verfügbaren Timerdaten anzeigen. [|cFF99CC33AUS|r]"
L.NoTimerBarsChkBtn = "Graue \226\136\158-Leisten anzeigen, wenn keine Timerdaten verfügbar sind."

L.RetailWarningTitle = "RETAIL (MIDNIGHT) — BITTE LESEN"
L.RetailWarningBody = "xanDebuffTimers hat jetzt eine verbesserte Retail-Unterstützung, aber das Verhalten hängt davon ab, wo du dich befindest:\n\n|cFF00FF00OFFENE WELT / SCHLACHTFELDER:|r\nVoll funktionsfähig. Debuff-Symbole, Timer und Balken werden normal angezeigt.\n\n|cFFFFFF00INSTANZEN / SCHLACHTZÜGE / ARENEN:|r\nDebuff-Symbole und Namen werden weiterhin angezeigt, aber Timer-Balken zeigen |cFFFFFFFF\226\136\158|r (Unendlich), da Blizzard den Zugriff auf Timingdaten in diesen Kontexten einschränkt. Zauber auf Blizzards interner Whitelist zeigen auch in Instanzen vollständige Timer — diese Liste wird nach und nach erweitert.\n\n|cFFFF2020Dies ist eine Blizzard-Einschränkung (\"secret values\"), kein Bug.|r\n\nDas Addon stürzt durch diese Einschränkung nie ab — es wechselt automatisch zur Symbol-Anzeige, wenn Timingdaten nicht verfügbar sind.\n\nDieses Addon bleibt auf allen Classic-Clients (Era, SoD, Cata, Wrath) vollständig funktionsfähig, wo diese Einschränkungen nicht gelten."
