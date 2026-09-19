local ADDON_NAME, private = ...

local L = private:NewLocale("zhTW")
if not L then return end

L.SlashAnchor = "anchor"
L.SlashAnchorText = "Toggle Frame Anchors"
L.SlashAnchorOn = "xanDebuffTimers: Anchors now [|cFF99CC33SHOWN|r]"
L.SlashAnchorOff = "xanDebuffTimers: Anchors now [|cFF99CC33HIDDEN|r]"
L.SlashAnchorInfo = "Toggles movable anchors."

L.SlashReset = "reset"
L.SlashResetText = "Reset Anchor Positions"
L.SlashResetInfo = "Reset anchor positions."

L.Reset = "重置"

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

L.GraphicBarChkBtn = "使用圖形化減益條。"
L.BarColorText = "減益條顏色。"

L.NoTimerBarsOn = "xanDebuffTimers: 當計時器資料不可用時顯示灰色 \226\136\158 條。[|cFF99CC33開|r]"
L.NoTimerBarsOff = "xanDebuffTimers: 當計時器資料不可用時顯示灰色 \226\136\158 條。[|cFF99CC33關|r]"
L.NoTimerBarsChkBtn = "當計時器資料不可用時顯示灰色 \226\136\158 條。"

L.RetailWarningTitle = "正式服 (午夜) — 請閱讀"
L.RetailWarningBody = "xanDebuffTimers 現已改善對正式服的支援，但功能表現取決於你所在的位置：\n\n|cFF00FF00開放世界 / 戰場：|r\n完全正常運作。Debuff 圖示、計時器和進度條均正常顯示。\n\n|cFFFFFF00副本 / 團隊副本 / 競技場：|r\nDebuff 圖示和名稱仍會顯示，但計時條將顯示為 |cFFFFFFFF\226\136\158|r（無限），因為 Blizzard 在這些情境中限制了對時間資料的存取。在 Blizzard 內部白名單上的法術即使在副本中也能顯示完整計時器——該白名單正在逐步擴充。\n\n|cFFFF2020這是 Blizzard 的限制（\"秘密值\"），並非插件 Bug。|r\n\n插件不會因此限制而崩潰——當時間資料不可用時，它會自動降級為僅顯示圖示的模式。\n\n此插件在所有不受這些限制影響的懷舊版客戶端（經典版、SoD、浩劫、巫妖王）上仍可完全正常使用。"
