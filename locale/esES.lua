local ADDON_NAME, private = ...

local L = private:NewLocale("esES")
if not L then return end

L.SlashAnchor = "anchor"
L.SlashAnchorText = "Toggle Frame Anchors"
L.SlashAnchorOn = "xanDebuffTimers: Anchors now [|cFF99CC33SHOWN|r]"
L.SlashAnchorOff = "xanDebuffTimers: Anchors now [|cFF99CC33HIDDEN|r]"
L.SlashAnchorInfo = "Toggles movable anchors."

L.SlashReset = "reset"
L.SlashResetText = "Reset Anchor Positions"
L.SlashResetInfo = "Reset anchor positions."

L.Reset = "Restablecer"

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

L.GraphicBarChkBtn = "Usar barras gráficas de perjuicios."
L.BarColorText = "Color de la barra de perjuicio."

L.NoTimerBarsOn = "xanDebuffTimers: Mostrar barras grises \226\136\158 cuando los datos de temporización no están disponibles. [|cFF99CC33ON|r]"
L.NoTimerBarsOff = "xanDebuffTimers: Mostrar barras grises \226\136\158 cuando los datos de temporización no están disponibles. [|cFF99CC33OFF|r]"
L.NoTimerBarsChkBtn = "Mostrar barras grises \226\136\158 cuando los datos de temporización no están disponibles."

L.RetailWarningTitle = "RETAIL (MIDNIGHT) — POR FAVOR LEA"
L.RetailWarningBody = "xanDebuffTimers ahora tiene soporte mejorado para Retail, pero el comportamiento depende de dónde estés:\n\n|cFF00FF00MUNDO ABIERTO / CAMPOS DE BATALLA:|r\nTotalmente funcional. Los iconos de debuffs, temporizadores y barras se muestran con normalidad.\n\n|cFFFFFF00INSTANCIAS / INCURSIONES / ARENAS:|r\nLos iconos y nombres de los debuffs siguen mostrándose, pero las barras de tiempo muestran |cFFFFFFFF\226\136\158|r (infinito) porque Blizzard restringe el acceso a los datos de temporización en estos contextos. Los hechizos en la lista blanca interna de Blizzard mostrarán temporizadores completos incluso en instancias — esta lista se va ampliando gradualmente.\n\n|cFFFF2020Esta es una restricción de Blizzard (\"valores secretos\"), no un error.|r\n\nEl addon nunca se bloqueará por esta restricción — pasa automáticamente a mostrar solo iconos cuando los datos de temporización no están disponibles.\n\nEste addon sigue siendo totalmente funcional en todos los clientes Classic (Era, SoD, Cata, Wrath) donde estas restricciones no se aplican."
