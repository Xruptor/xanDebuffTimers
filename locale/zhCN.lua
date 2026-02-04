local ADDON_NAME, private = ...

local L = private:NewLocale("zhCN")
if not L then return end

L.SlashAnchor = "锚点"
L.SlashAnchorText = "切换移动锚点"
L.SlashAnchorOn = "xanDebuffTimers: 锚点现在 [|cFF99CC33显示|r]"
L.SlashAnchorOff = "xanDebuffTimers: 锚点现在 [|cFF99CC33隐藏|r]"
L.SlashAnchorInfo = "切换可移动锚点。"

L.SlashReset = "重置"
L.SlashResetText = "重置锚点位置"
L.SlashResetInfo = "重置锚点位置。"
L.SlashResetAlert = "xanDebuffTimers: 锚点位置已重置！"

L.SlashScale = "缩放"
L.SlashScaleSet = "xanDebuffTimers: 缩放比列设置为 [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "缩放无效！数字必需为 [0.5 - 5].  (0.5, 1, 3, 4.6, 等..)"
L.SlashScaleInfo = "设置xanDebuffTimers比例为 (0.5 - 5)。"
L.SlashScaleText = "xanDebuffTimers 比例"

L.SlashGrow = "增长方向"
L.SlashGrowUp = "xanDebuffTimers: 现在增长方向为 [|cFF99CC33上|r]"
L.SlashGrowDown = "xanDebuffTimers: 现在增长方向为 [|cFF99CC33下|r]"
L.SlashGrowInfo = "切换增长方向为 (|cFF99CC33上/下|r)。"
L.SlashGrowChkBtn = "增长方向 [|cFF99CC33下|r]。"

L.SlashSort = "排序"
L.SlashSortDescending = "xanDebuffTimers: 排序选择为 [|cFF99CC33降序|r]"
L.SlashSortAscending = "xanDebuffTimers: 排序选择为 [|cFF99CC33升序|r]"
L.SlashSortInfo = "切换排序方式为 (|cFF99CC33升序/降序|r)。"
L.SlashSortChkBtn = "排序选择 [|cFF99CC33升序|r]。"

L.SlashReload = "重载"
L.SlashReloadText = "重载减益条"
L.SlashReloadInfo = "重载减益条。"
L.SlashReloadAlert = "xanDebuffTimers: 重新加载减益条！"

L.SlashInfinite = "无限制"
L.SlashInfiniteOn = "xanDebuffTimers: 显示无持续时间/计时器或无计时的减益 [|cFF99CC33开|r]"
L.SlashInfiniteOff = "xanDebuffTimers: 显示无持续时间/计时器或无计时的减益 [|cFF99CC33关|r]"
L.SlashInfiniteInfo = "切换显示无持续时间/计时器或无计时的减益 (|cFF99CC33开/关|r)。"
L.SlashInfiniteChkBtn = "显示无持续时间/计时器或无计时的增益为 [|cFF99CC33开|r]。"

L.TimeHour = "h"
L.TimeMinute = "m"
L.TimeSecond = "s"

L.BarTargetAnchor = "xanDebuffTimers: 目标锚点"
L.BarFocusAnchor = "xanDebuffTimers: 焦点锚点"
