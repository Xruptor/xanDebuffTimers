local ADDON_NAME, private = ...

local L = private:NewLocale("koKR")
if not L then return end

L.SlashAnchor = "anchor"
L.SlashAnchorText = "Toggle Frame Anchors"
L.SlashAnchorOn = "xanDebuffTimers: Anchors now [|cFF99CC33SHOWN|r]"
L.SlashAnchorOff = "xanDebuffTimers: Anchors now [|cFF99CC33HIDDEN|r]"
L.SlashAnchorInfo = "Toggles movable anchors."

L.SlashReset = "reset"
L.SlashResetText = "Reset Anchor Positions"
L.SlashResetInfo = "Reset anchor positions."

L.Reset = "초기화"

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

L.GraphicBarChkBtn = "그래픽 디버프 바 사용."
L.BarColorText = "디버프 바 색상."

L.RetailWarningTitle = "경고 꼭 읽어주세요!!! 리테일 전용"
L.RetailWarningBody = "이 애드온은 Blizzard의 API 변경으로 인해 Retail에서 더 이상 작동할 수 없습니다.\n\nBlizzard는 전투 관련 오라 데이터를 보호된 \"신중한 값\"으로 표시합니다. 즉, 전투 중에는 디버프 지속 시간과 만료 시간 등 전투 데이터를 애드온이 읽거나 계산할 수 없습니다. 이 애드온은 남은 시간을 계산해 바를 그려야 하므로, 핵심 기능이 클라이언트 자체에서 차단됩니다.\n\n|cFFFFFF00이것은 xanDebuffTimers의 버그가 아니에요.|r\n\n|cFFFF2020Blizzard가 제한한 제약 사항입니다.|r\n\nWeakAuras 등 다른 유사한 오라/타이머 애드온도 같은 문제를 겪고 있으며, Retail에서 정확한 전투 타이머를 표시할 수 없습니다.\n\n요약: Retail은 이 애드온이 필요로 하는 정확한 데이터에 접근하지 못하게 하므로, 디버프 바가 작동하지 않습니다. 이 애드온은 Classic, TBC, Wrath 등 비-Retail 클라이언트에서는 정상 작동합니다."
