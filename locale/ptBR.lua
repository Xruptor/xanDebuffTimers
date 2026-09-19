local ADDON_NAME, private = ...

local L = private:NewLocale("ptBR")
if not L then return end

L.SlashAnchor = "anchor"
L.SlashAnchorText = "Toggle Frame Anchors"
L.SlashAnchorOn = "xanDebuffTimers: Anchors now [|cFF99CC33SHOWN|r]"
L.SlashAnchorOff = "xanDebuffTimers: Anchors now [|cFF99CC33HIDDEN|r]"
L.SlashAnchorInfo = "Toggles movable anchors."

L.SlashReset = "reset"
L.SlashResetText = "Reset Anchor Positions"
L.SlashResetInfo = "Reset anchor positions."

L.Reset = "Reiniciar"

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

L.GraphicBarChkBtn = "Usar barras gráficas de debuffs."
L.BarColorText = "Cor da barra de debuff."

L.NoTimerBarsOn = "xanDebuffTimers: Mostrar barras cinzas \226\136\158 quando os dados do temporizador não estão disponíveis. [|cFF99CC33ON|r]"
L.NoTimerBarsOff = "xanDebuffTimers: Mostrar barras cinzas \226\136\158 quando os dados do temporizador não estão disponíveis. [|cFF99CC33OFF|r]"
L.NoTimerBarsChkBtn = "Mostrar barras cinzas \226\136\158 quando os dados do temporizador não estão disponíveis."

L.RetailWarningTitle = "RETAIL (MIDNIGHT) — POR FAVOR LEIA"
L.RetailWarningBody = "xanDebuffTimers agora tem suporte aprimorado para Retail, mas o comportamento depende de onde você está:\n\n|cFF00FF00MUNDO ABERTO / CAMPOS DE BATALHA:|r\nTotalmente funcional. Ícones de debuffs, temporizadores e barras são exibidos normalmente.\n\n|cFFFFFF00INSTÂNCIAS / RAIDS / ARENAS:|r\nÍcones e nomes dos debuffs ainda são exibidos, mas as barras de tempo mostram |cFFFFFFFF\226\136\158|r (infinito) porque Blizzard restringe o acesso a dados de temporização nesses contextos. Feitiços na lista branca interna da Blizzard mostrarão temporizadores completos mesmo em instâncias — esta lista está se expandindo gradualmente.\n\n|cFFFF2020Esta é uma restrição da Blizzard (\"valores secretos\"), não um bug.|r\n\nO addon nunca vai travar por causa dessa restrição — ele degrada automaticamente para exibição apenas de ícones quando os dados de temporização não estão disponíveis.\n\nEste addon permanece totalmente funcional em todos os clientes Classic (Era, SoD, Cata, Wrath) onde essas restrições não se aplicam."
