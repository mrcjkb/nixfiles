import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Fullscreen

-- Modules in ~/.xmonad/lib directory

import Defaults
import EventHandling
import KeyBindings
import Layout
import LogHook
import MouseBindings
import StartupHook
import WindowRules

main :: IO ()
main = xmonad . withStatusBars . fullscreenSupport . docks . ewmh $ defaults
  where
    defaults =
      def
        { terminal = myTerminal
        , focusFollowsMouse = myFocusFollowsMouse
        , clickJustFocuses = myClickJustFocuses
        , borderWidth = myBorderWidth
        , modMask = myModMask
        , workspaces = myWorkspaces
        , normalBorderColor = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , keys = myKeys
        , mouseBindings = myMouseBindings
        , manageHook = myManageHook
        , layoutHook = myLayoutHook
        , handleEventHook = myEventHook
        , logHook = myLogHook
        , startupHook = myStartupHook
        }
