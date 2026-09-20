module Xmobar.Plugin.Profile (mkProfile) where

import Data.List.Extra (isInfixOf, stripSuffix)
import System.Process (readProcess)
import Xmobar

data Profile
  = TuxedoProfile
  | UnknownProfile
  deriving (Read, Show)

instance Exec Profile where
  alias _ = "profile"
  rate UnknownProfile = 1000
  rate TuxedoProfile = 5
  run UnknownProfile = pure ""
  run TuxedoProfile = do
    profileInfo <- readProcess "tailor" ["profile", "list"] []
    let activeProfiles = filter ("(active)" `isInfixOf`) $ lines profileInfo
    pure $ case activeProfiles of
      [] -> "unknown profile"
      activeProfile : _ -> case stripSuffix " (active)" activeProfile of
        Just prefix -> prefix
        _ -> activeProfile

mkProfile :: IO (String, Profile)
mkProfile = do
  hostName <- readProcess "hostname" [] []
  pure $
    if "nixos-tux" `isInfixOf` hostName
      then -- 󰓅
        (" \984261 %profile% ", TuxedoProfile)
      else (" ", UnknownProfile)
