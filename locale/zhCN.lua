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

L.NoTimerBarsOn = "xanDebuffTimers: 当计时器数据不可用时显示灰色 \226\136\158 条。[|cFF99CC33开|r]"
L.NoTimerBarsOff = "xanDebuffTimers: 当计时器数据不可用时显示灰色 \226\136\158 条。[|cFF99CC33关|r]"
L.NoTimerBarsChkBtn = "当计时器数据不可用时显示灰色 \226\136\158 条。"

L.RetailWarningTitle = "正式服 (午夜) — 请阅读"
L.RetailWarningBody = "xanDebuffTimers 现已改善对正式服的支持，但功能表现取决于你所在的位置：\n\n|cFF00FF00开放世界 / 战场：|r\n完全正常运作。Debuff 图标、计时器和进度条均正常显示。\n\n|cFFFFFF00副本 / 团队副本 / 竞技场：|r\nDebuff 图标和名称仍会显示，但计时条将显示为 |cFFFFFFFF\226\136\158|r（无限），因为 Blizzard 在这些场景中限制了对时间数据的访问。在 Blizzard 内部白名单上的法术即使在副本中也能显示完整计时器——该白名单正在逐步扩充。\n\n|cFFFF2020这是 Blizzard 的限制（\"秘密值\"），并非插件 Bug。|r\n\n插件不会因此限制而崩溃——当时间数据不可用时，它会自动降级为仅显示图标的模式。\n\n此插件在所有不受这些限制影响的经典版客户端（经典版、SoD、浩劫、巫妖王）上仍可完全正常使用。"
