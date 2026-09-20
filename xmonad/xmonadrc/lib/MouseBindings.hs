module MouseBindings where

import qualified Data.Map as Map
import XMonad
import qualified XMonad.StackSet as W

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig l -> Map.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig{modMask = modm}) =
  Map.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [
      ( (modm, button1)
      , \w ->
          focus w
            >> mouseMoveWindow w
            >> windows W.shiftMaster
      )
    , -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster)
    , -- mod-button3, Set the window to floating mode and resize by dragging

      ( (modm, button3)
      , \w ->
          focus w
            >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
