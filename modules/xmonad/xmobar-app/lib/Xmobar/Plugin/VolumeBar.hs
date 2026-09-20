{-# LANGUAGE ScopedTypeVariables #-}

module Xmobar.Plugin.VolumeBar (VolumeBar (..)) where

import Data.List (isInfixOf)
import System.Process (readProcess)
import Xmobar

data VolumeBar = VolumeBar
  deriving (Read, Show)

instance Exec VolumeBar where
  alias VolumeBar = "volbar"
  rate VolumeBar = 5
  run VolumeBar = do
    muteStatus <- readProcess "pamixer" ["--get-mute"] []
    if "true" `isInfixOf` muteStatus
      then pure $ wrapAction "pamixer --unmute" "\60196"
      else getVolume
    where
      parse v = read (takeWhile (/= '%') v) :: Int
      setVolumeCmd v = "pamixer --set-volume " ++ show (10 * v)
      getVolume = do
        volume <- parse <$> readProcess "pamixer" ["--get-volume"] []
        pure $ slider volume 10 setVolumeCmd "\62532" "·"

slider :: Int -> Int -> (Int -> String) -> String -> String -> String
slider value barWidth mkSetVolumeCmd filledSymbol emptySymbol = wrap mute " \60277" bar
  where
    mute = wrapAction "pamixer --mute" "\60196 "
    percentage :: Double = fromIntegral value / 100

    filledSize = ceiling (fromIntegral barWidth * percentage)

    mkSymbol :: Int -> String
    mkSymbol i =
      if i < filledSize
        then filledSymbol
        else emptySymbol

    bar = mconcat [wrapAction (mkSetVolumeCmd i) (mkSymbol i) | i <- [0 .. barWidth - 1]]

wrap :: String -> String -> String -> String
wrap a1 a2 b = a1 <> b <> a2

wrapAction :: String -> String -> String
wrapAction command = wrap ("<action=" <> command <> ">") "</action>"
