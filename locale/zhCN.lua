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

L.Reset = "重置"

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

L.GraphicBarChkBtn = "使用图形化减益条。"
L.BarColorText = "减益条颜色。"

L.RetailWarningTitle = "警告 请务必阅读!!! 仅限正式服"
L.RetailWarningBody = "由于 Blizzard 的 API 更改，本插件在正式服已无法正常运作。\n\nBlizzard 现在将战斗相关的光环数据标记为受保护的"秘密值"。这意味着插件在战斗中无法读取或计算 Debuff 持续时间、到期时间等数据。而本插件必须计算剩余时间才能绘制进度条，因此核心功能被客户端直接阻止。\n\n|cFFFFFF00这不是 xanDebuffTimers 的 Bug。|r\n\n|cFFFF2020这是 Blizzard 强制施加的限制。|r\n\n类似的光环/计时插件（例如 WeakAuras 及其他 Buff/Debuff 追踪插件）也遭遇同样问题，无法在正式服中显示准确的战斗计时。\n\n简而言之：正式服阻止了本插件所需的精确数据，因此 Debuff 条无法工作。本插件在 Classic、TBC、Wrath 等非正式服客户端中仍可正常运行。"
