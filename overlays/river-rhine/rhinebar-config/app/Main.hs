module Main (main) where

import Data.Colour qualified as Colour
import Data.Colour.SRGB (sRGB24)
import Data.Default (def)
import Effectful (IOE, (:>))
import Graphics.Rendering.Pango qualified as Pango
import Rhinebar
  ( Config (..)
  , Heading (..)
  , MainBar (..)
  , Screen (..)
  , Theme (..)
  , segment
  )
import Rhinebar qualified
import Rhinebar.Clock qualified as Clock
import Rhinebar.Segment (Role (..))
import Rhinebar.Source (Source)
import Rhinebar.Weather (Wttr (..))
import Prelude

main :: IO ()
main = Rhinebar.main config

config :: Config '[Source, IOE]
config =
  Config
    { screen = MainBarScreen mainBar
    , statusPath = Nothing
    , theme = barTheme
    }

mainBar :: (Source :> es, IOE :> es) => MainBar es
mainBar =
  MainBar
    { leading =
        [ segment "\62227" Info
        , segment "\59255" Accent
        ]
    , separator = " \57533 "
    , tabSeparator = " \57533 "
    , tabLayouts = ["Full", "Scroll"]
    , tabMinWidth = Nothing
    , title = TitleAndTabs
    , indicators =
        [ Clock.battery
        , Clock.date
        , Clock.volume
        , Clock.memory
        , Clock.network
        , Clock.weather $ Wttr "zurich"
        ]
    }

barTheme :: Theme
barTheme =
  def
    { font = Just "JetBrains Mono Nerd Font Mono"
    , fontWeight = Pango.WeightBold
    , info = Colour.opaque $ sRGB24 0x89 0xb4 0xfa
    }
