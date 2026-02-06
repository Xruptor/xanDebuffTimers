local ADDON_NAME, private = ...

local L = private:NewLocale("ruRU")
if not L then return end
-- Translator ZamestoTV
L.SlashAnchor = "якорь"
L.SlashAnchorText = "Переключить якоря фрейма"
L.SlashAnchorOn = "xanDebuffTimers: Якоря теперь [|cFF99CC33ПОКАЗАНЫ|r]"
L.SlashAnchorOff = "xanDebuffTimers: Якоря теперь [|cFF99CC33СКРЫТЫ|r]"
L.SlashAnchorInfo = "Переключает подвижные якоря."

L.SlashReset = "сброс"
L.SlashResetText = "Сбросить позиции якорей"
L.SlashResetInfo = "Сбрасывает позиции якорей."

L.Reset = "Сброс"

L.SlashScale = "масштаб"
L.SlashScaleSet = "xanDebuffTimers: Масштаб установлен на [|cFF20ff20%s|r]"
L.SlashScaleSetInvalid = "Неверный масштаб! Число должно быть в диапазоне [0.5 - 5]. (0.5, 1, 3, 4.6 и т.д.)"
L.SlashScaleInfo = "Установить масштаб фреймов добычи LootRollMover (0.5 - 5)."
L.SlashScaleText = "Масштаб полос xanDebuffTimers"

L.SlashGrow = "рост"
L.SlashGrowUp = "xanDebuffTimers: Полосы будут расти [|cFF99CC33ВВЕРХ|r]"
L.SlashGrowDown = "xanDebuffTimers: Полосы будут расти [|cFF99CC33ВНИЗ|r]"
L.SlashGrowInfo = "Переключить направление роста полос (|cFF99CC33ВВЕРХ/ВНИЗ|r)."
L.SlashGrowChkBtn = "Полосы будут расти [|cFF99CC33ВНИЗ|r]."

L.SlashSort = "сортировка"
L.SlashSortDescending = "xanDebuffTimers: Полосы будут сортироваться [|cFF99CC33ПО УБЫВАНИЮ|r]"
L.SlashSortAscending = "xanDebuffTimers: Полосы будут сортироваться [|cFF99CC33ПО ВОЗРАСТАНИЮ|r]"
L.SlashSortInfo = "Переключить сортировку полос. (|cFF99CC33ПО ВОЗРАСТАНИЮ/ПО УБЫВАНИЮ|r)."
L.SlashSortChkBtn = "Полосы будут сортироваться [|cFF99CC33ПО ВОЗРАСТАНИЮ|r]."

L.SlashReload = "перезагрузка"
L.SlashReloadText = "Перезагрузить полосы дебаффов"
L.SlashReloadInfo = "Перезагружает полосы дебаффов."
L.SlashReloadAlert = "xanDebuffTimers: Полосы дебаффов перезагружены!"

L.SlashInfinite = "бесконечный"
L.SlashInfiniteOn = "xanDebuffTimers: Показывать дебаффы без длительности/таймеров или бесконечные. [|cFF99CC33ВКЛ|r]"
L.SlashInfiniteOff = "xanDebuffTimers: Показывать дебаффы без длительности/таймеров или бесконечные. [|cFF99CC33ВЫКЛ|r]"
L.SlashInfiniteInfo = "Переключает отображение дебаффов без длительности/таймеров или бесконечных. (|cFF99CC33ВКЛ/ВЫКЛ|r)."
L.SlashInfiniteChkBtn = "Показывать дебаффы без длительности/таймеров или бесконечные. [|cFF99CC33ВКЛ|r]."

L.TimeHour = "ч"
L.TimeMinute = "м"
L.TimeSecond = "с"

L.BarTargetAnchor = "xanDebuffTimers: Якорь цели"
L.BarFocusAnchor = "xanDebuffTimers: Якорь фокуса"

L.IconChkBtn = "Показывать иконки дебаффов. [|cFF99CC33ВКЛ|r]."
L.SpellNameChkBtn = "Показывать названия заклинаний дебаффов. [|cFF99CC33ВКЛ|r]."
L.HideInRested = "Скрывать полосы дебаффов в зоне отдыха."
L.ShowTimerOnRight = "Показывать таймер справа от иконки дебаффа."

L.GraphicBarChkBtn = "Использовать графические полосы дебаффов."
L.BarColorText = "Цвет полосы дебаффов."

L.RetailWarningTitle = "ВНИМАНИЕ ПРОЧТИТЕ!!! ТОЛЬКО RETAIL"
L.RetailWarningBody = "Этот аддон больше не может работать на Retail из-за изменений API от Blizzard.\n\nBlizzard теперь помечает боевые данные аур как защищенные "секретные значения". Это означает, что аддоны не могут читать или вычислять длительность дебаффов, время окончания и другие боевые данные во время боя. Так как этот аддон должен вычислять оставшееся время для отрисовки полос, клиент блокирует его основную функциональность.\n\n|cFFFFFF00Это не баг xanDebuffTimers.|r\n\n|cFFFF2020Это ограничение, введённое Blizzard.|r\n\nПохожие аддоны аур/таймеров (например, WeakAuras и другие трекеры баффов/дебаффов) столкнулись с той же проблемой и не могут показывать точные таймеры в бою на Retail.\n\nКороче: Retail блокирует доступ к точным данным, нужным этому аддону, поэтому бары дебаффов не будут работать. Этот аддон остаётся полностью работоспособным на Classic, TBC, Wrath и других не-Retail клиентах."
