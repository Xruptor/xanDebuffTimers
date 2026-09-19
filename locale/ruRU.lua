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

L.NoTimerBarsOn = "xanDebuffTimers: Показывать серые полосы \226\136\158, когда данные таймера недоступны. [|cFF99CC33ВКЛ|r]"
L.NoTimerBarsOff = "xanDebuffTimers: Показывать серые полосы \226\136\158, когда данные таймера недоступны. [|cFF99CC33ВЫКЛ|r]"
L.NoTimerBarsChkBtn = "Показывать серые полосы \226\136\158, когда данные таймера недоступны."

L.RetailWarningTitle = "RETAIL (MIDNIGHT) — ПРОЧТИТЕ"
L.RetailWarningBody = "xanDebuffTimers теперь имеет улучшенную поддержку Retail, но поведение зависит от того, где вы находитесь:\n\n|cFF00FF00ОТКРЫТЫЙ МИР / ПОЛЯ БОЯ:|r\nПолностью функционирует. Иконки дебаффов, таймеры и полосы отображаются нормально.\n\n|cFFFFFF00ПОДЗЕМЕЛЬЯ / РЕЙДЫ / АРЕНЫ:|r\nИконки и названия дебаффов по-прежнему отображаются, но полосы таймеров показывают |cFFFFFFFF\226\136\158|r (бесконечность), так как Blizzard ограничивает доступ к данным о времени в этих контекстах. Заклинания из внутреннего белого списка Blizzard будут показывать полные таймеры даже в подземельях — этот список постепенно расширяется.\n\n|cFFFF2020Это ограничение Blizzard («секретные значения»), а не ошибка.|r\n\nАддон никогда не вылетит из-за этого ограничения — при отсутствии данных о времени он автоматически переходит к отображению только иконок.\n\nЭтот аддон остаётся полностью работоспособным на всех клиентах Classic (Era, SoD, Cata, Wrath), где данные ограничения не действуют."
