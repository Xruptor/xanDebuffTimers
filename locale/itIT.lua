local ADDON_NAME, private = ...

local L = private:NewLocale("itIT")
if not L then return end

L.SlashAnchor = "anchor"
L.SlashAnchorText = "Toggle Frame Anchors"
L.SlashAnchorOn = "xanDebuffTimers: Anchors now [|cFF99CC33SHOWN|r]"
L.SlashAnchorOff = "xanDebuffTimers: Anchors now [|cFF99CC33HIDDEN|r]"
L.SlashAnchorInfo = "Toggles movable anchors."

L.SlashReset = "reset"
L.SlashResetText = "Reset Anchor Positions"
L.SlashResetInfo = "Reset anchor positions."

L.Reset = "Ripristino"

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

L.GraphicBarChkBtn = "Usa barre grafiche dei debilitazioni."
L.BarColorText = "Colore della barra di debilitazione."

L.NoTimerBarsOn = "xanDebuffTimers: Mostra le barre grigie \226\136\158 quando i dati del timer non sono disponibili. [|cFF99CC33ON|r]"
L.NoTimerBarsOff = "xanDebuffTimers: Mostra le barre grigie \226\136\158 quando i dati del timer non sono disponibili. [|cFF99CC33OFF|r]"
L.NoTimerBarsChkBtn = "Mostra le barre grigie \226\136\158 quando i dati del timer non sono disponibili."

L.RetailWarningTitle = "RETAIL (MIDNIGHT) — SI PREGA DI LEGGERE"
L.RetailWarningBody = "xanDebuffTimers ora offre un supporto migliorato per Retail, ma il comportamento dipende da dove ti trovi:\n\n|cFF00FF00MONDO APERTO / CAMPI DI BATTAGLIA:|r\nCompletamente funzionale. Le icone dei debuff, i timer e le barre vengono visualizzati normalmente.\n\n|cFFFFFF00ISTANZE / INCURSIONI / ARENE:|r\nLe icone e i nomi dei debuff vengono ancora mostrati, ma le barre del timer visualizzano |cFFFFFFFF\226\136\158|r (infinito) perché Blizzard limita l’accesso ai dati di temporizzazione in questi contesti. Gli incantesimi nella whitelist interna di Blizzard mostreranno timer completi anche nelle istanze — questa lista si sta gradualmente espandendo.\n\n|cFFFF2020Questa è una restrizione di Blizzard (\"valori segreti\"), non un bug.|r\n\nL’addon non si bloccherà mai a causa di questa restrizione — degrada automaticamente alla visualizzazione delle sole icone quando i dati di temporizzazione non sono disponibili.\n\nQuesto addon rimane completamente funzionale su tutti i client Classic (Era, SoD, Cata, Wrath) dove queste restrizioni non si applicano."
