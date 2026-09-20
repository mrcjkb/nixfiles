{-# LANGUAGE FlexibleContexts #-}

module LogHook
  ( withStatusBars
  , myLogHook
  ) where

import Layout (ppLayoutOverride)
import XMonad
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.StatusBar' extension for examples.

myLogHook :: X ()
myLogHook = pure ()

withStatusBars :: (LayoutClass l Window) => XConfig l -> XConfig l
withStatusBars = dynamicSBs barSpawner

barSpawner :: ScreenId -> X StatusBarConfig
barSpawner = pure . xmobar
  where
    pp :: PP
    pp =
      def
        { ppCurrent = xmobarColor "#f9e2af" "" . wrap "[" "]"
        , ppTitle = xmobarColor "#cba6f7" "" . shorten 40
        , ppVisible = wrap "(" ")"
        , ppUrgent = xmobarColor "#f38ba8" "#f9e2af"
        , ppSep = " \57533 "
        , ppLayout = ppLayoutOverride
        }
    xmobar :: ScreenId -> StatusBarConfig
    xmobar (S screenId) = statusBarProp ("xmobar-app -x " <> show screenId) $ pure pp
