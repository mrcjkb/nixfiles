module StartupHook (myStartupHook) where

import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Util.SpawnOnce

import Control.Monad
import Data.Maybe

------------------------------------------------------------------------

-- | Startup hook

{- | Perform an arbitrary action each time xmonad starts or is restarted
 | with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
 | per-workspace layout choices.
-}
myStartupHook :: X ()
myStartupHook =
  do
    spawn "xsetroot -cursor_name left_ptr"
    spawn "autorandr -c"
    spawnOnce "greenclip daemon"
    spawnOnce "nextcloud-wrapper" -- Also spawns keepassxc
    setWMName "LG3D"
    >> addEWMHFullscreen

addNETSupported :: Atom -> X ()
addNETSupported x = withDisplay $ \dpy -> do
  r <- asks theRoot
  a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
  a <- getAtom "ATOM"
  liftIO $ do
    sup <- join . maybeToList <$> getWindowProperty32 dpy a_NET_SUPPORTED r
    unless (fromIntegral x `elem` sup) $
      changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen = do
  wms <- getAtom "_NET_WM_STATE"
  wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
  mapM_ addNETSupported [wms, wfs]
