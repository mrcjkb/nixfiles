{-# OPTIONS_GHC -Wno-missing-signatures #-}

module Layout
  ( myLayoutHook
  , ppLayoutOverride
  ) where

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Gaps
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

myLayoutHook =
  gaps [(L, 0), (R, 0), (U, 0), (D, 0)] $
    spacingRaw True (Border 0 0 0 0) True (Border 0 0 0 0) True $
      smartBorders myLayout
  where
    myLayout =
      smartBorders $
        mkToggle (NOBORDERS ?? FULL ?? EOT) $
          avoidStruts
            ( reflectHoriz tiled
                ||| magnifier (reflectHoriz tiled)
                ||| Mirror tiled
                ||| magnifier (Mirror tiled)
                ||| Full
                -- large master window in the center. Windows tile to the left and right
                -- (for ultra wide displays)
                ||| ThreeColMid 1 (3 / 100) (3 / 7)
                ||| magnifier (ThreeColMid 1 (3 / 100) (3 / 7))
            )
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2

    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

ppLayoutOverride :: String -> String
ppLayoutOverride "Spacing Magnifier ReflectX Tall" = "|-|\983881|" -- 󰍉
ppLayoutOverride "Spacing ReflectX Tall" = "|-| |"
ppLayoutOverride "Spacing Magnifier Mirror Tall" = "|\983881.-|"
ppLayoutOverride "Spacing Mirror Tall" = "|-.-|"
ppLayoutOverride "Spacing Full" = "| |"
ppLayoutOverride "Spacing Magnifier ThreeCol" = "|-|\983881|-|"
ppLayoutOverride "Spacing ThreeCol" = "|-| |-|"
ppLayoutOverride layout = layout
