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

L.NoTimerBarsOn = "xanDebuffTimers: 타이머 데이터를 사용할 수 없을 때 회색 \226\136\158 막대 표시. [|cFF99CC33ON|r]"
L.NoTimerBarsOff = "xanDebuffTimers: 타이머 데이터를 사용할 수 없을 때 회색 \226\136\158 막대 표시. [|cFF99CC33OFF|r]"
L.NoTimerBarsChkBtn = "타이머 데이터를 사용할 수 없을 때 회색 \226\136\158 막대 표시."

L.RetailWarningTitle = "리테일 (미드나이트) — 꼭 읽어주세요"
L.RetailWarningBody = "xanDebuffTimers는 이제 리테일 지원이 향상되었지만, 동작은 위치에 따라 달라집니다:\n\n|cFF00FF00오픈 월드 / 전장:|r\n완전히 작동합니다. 디버프 아이콘, 타이머, 바가 정상적으로 표시됩니다.\n\n|cFFFFFF00인스턴스 / 레이드 / 투기장:|r\n디버프 아이콘과 이름은 계속 표시되지만, Blizzard가 이런 환경에서 타이밍 데이터 접근을 제한하기 때문에 타이머 바는 |cFFFFFFFF\226\136\158|r (무한대)로 표시됩니다. Blizzard 내부 허용 목록에 있는 주문은 인스턴스에서도 전체 타이머를 표시합니다 — 이 목록은 점점 늘어나고 있습니다.\n\n|cFFFF2020이것은 Blizzard의 제한 사항 (\"비밀 값\")이며, 버그가 아닙니다.|r\n\n이 제한으로 인해 애드온이 충돌하지 않습니다 — 타이밍 데이터를 사용할 수 없을 때 아이콘만 표시되는 방식으로 자동 전환됩니다.\n\n이 애드온은 이러한 제한이 적용되지 않는 모든 클래식 클라이언트 (에라, SoD, 카타, 격분)에서 완전히 작동합니다."
