module WindowState (toggleFloat) where

import qualified Data.Map as Map
import XMonad
import qualified XMonad.StackSet as W

-- | Toggles the window w between floating and tiled
toggleFloat :: Window -> X ()
toggleFloat w = windows $ \windowSet ->
  if Map.member w $ W.floating windowSet
    then W.sink w windowSet
    else W.float w floatingWindowRect windowSet
  where
    floatingWindowRect = W.RationalRect (1 / 3) (1 / 6) (1 / 2) (4 / 5)
