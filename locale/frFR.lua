local ADDON_NAME, private = ...

local L = private:NewLocale("frFR")
if not L then return end

L.SlashAnchor = "anchor"
L.SlashAnchorText = "Toggle Frame Anchors"
L.SlashAnchorOn = "xanDebuffTimers: Anchors now [|cFF99CC33SHOWN|r]"
L.SlashAnchorOff = "xanDebuffTimers: Anchors now [|cFF99CC33HIDDEN|r]"
L.SlashAnchorInfo = "Toggles movable anchors."

L.SlashReset = "reset"
L.SlashResetText = "Reset Anchor Positions"
L.SlashResetInfo = "Reset anchor positions."

L.Reset = "Réinitialiser"

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

L.GraphicBarChkBtn = "Utiliser des barres graphiques d’affaiblissement."
L.BarColorText = "Couleur de la barre d’affaiblissement."

L.RetailWarningTitle = "AVERTISSEMENT VEUILLEZ LIRE !!! RETAIL UNIQUEMENT"
L.RetailWarningBody = "Cet addon ne peut plus fonctionner sur Retail à cause des changements d’API de Blizzard.\n\nBlizzard marque désormais les données d’auras en combat comme des \"valeurs secrètes\" protégées. Cela signifie que les addons ne peuvent pas lire ni calculer les durées des debuffs, les temps d’expiration ou d’autres données de combat pendant le combat. Comme cet addon doit calculer le temps restant pour afficher les barres, sa fonctionnalité principale est bloquée par le client.\n\n|cFFFFFF00Ce n’est pas un bug de xanDebuffTimers.|r\n\n|cFFFF2020C’est une restriction imposée par Blizzard.|r\n\nDes addons d’auras/temporisateurs similaires (par exemple WeakAuras et d’autres trackers de buffs/debuffs) rencontrent le même problème et ne peuvent pas afficher des minuteries précises sur Retail.\n\nEn bref : Retail bloque l’accès aux données exactes dont cet addon a besoin, donc les barres de debuffs ne fonctionneront pas. Cet addon reste pleinement fonctionnel sur Classic, TBC, Wrath et les autres clients non-Retail."
