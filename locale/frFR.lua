local ADDON_NAME, private = ...

local L = private:NewLocale("frFR")
if not L then return end

L.SlashAnchor = "anchor"
L.SlashAnchorText = "Toggle Frame Anchors"
L.SlashAnchorOn = "xanDebuffTimers: Anchors now [|cFF99CC33SHOWN|r]"
L.SlashAnchorOff = "xanDebuffTimers: Anchors now [|cFF99CC33HIDDEN|r]"
L.SlashAnchorInfo = "Toggles movable anchors."

L.SlashReset = "reset"
L.SlashResetText = "Reset Anchor Positions"
L.SlashResetInfo = "Reset anchor positions."

L.Reset = "Réinitialiser"

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

L.GraphicBarChkBtn = "Utiliser des barres graphiques d’affaiblissement."
L.BarColorText = "Couleur de la barre d’affaiblissement."

L.NoTimerBarsOn = "xanDebuffTimers: Afficher les barres grises \226\136\158 quand les données de minuterie sont indisponibles. [|cFF99CC33ON|r]"
L.NoTimerBarsOff = "xanDebuffTimers: Afficher les barres grises \226\136\158 quand les données de minuterie sont indisponibles. [|cFF99CC33OFF|r]"
L.NoTimerBarsChkBtn = "Afficher les barres grises \226\136\158 quand les données de minuterie sont indisponibles."

L.RetailWarningTitle = "RETAIL (MIDNIGHT) — VEUILLEZ LIRE"
L.RetailWarningBody = "xanDebuffTimers bénéficie désormais d’une prise en charge améliorée pour Retail, mais le comportement dépend de l’endroit où vous vous trouvez :\n\n|cFF00FF00MONDE OUVERT / CHAMPS DE BATAILLE :|r\nPleinement fonctionnel. Les icônes de debuffs, les minuteries et les barres s’affichent normalement.\n\n|cFFFFFF00INSTANCES / RAIDS / ARÈNES :|r\nLes icônes et noms des debuffs sont toujours affichés, mais les barres de minuterie affichent |cFFFFFFFF\226\136\158|r (infini) car Blizzard restreint l’accès aux données de chronométrage dans ces contextes. Les sorts figurant sur la liste blanche interne de Blizzard affichent des minuteries complètes même dans les instances — cette liste s’étend progressivement.\n\n|cFFFF2020Il s’agit d’une restriction de Blizzard (\"valeurs secrètes\"), pas d’un bug.|r\n\nL’addon ne plantera jamais à cause de cette restriction — il se dégrade proprement vers un affichage d’icône uniquement lorsque les données de chronométrage sont indisponibles.\n\nCet addon reste entièrement fonctionnel sur tous les clients Classic (Era, SoD, Cata, Wrath) où ces restrictions ne s’appliquent pas."
