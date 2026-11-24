module Main where

import Control.Monad (void)
import Data.Default (def)
import Data.List.NonEmpty (NonEmpty (..))
import Data.Text (Text)
import KeyBindings qualified
import River.Rhine.App qualified as App
import River.Rhine.Appearance.Border (Border (..))
import River.Rhine.Appearance.Colour qualified as Colour
import River.Rhine.Config (Config (..), FloatRule (..))
import River.Rhine.Help qualified as Help
import River.Rhine.Layout qualified as Layout
import River.Rhine.Layout.Transform qualified as Transform
import River.Rhine.Libinput qualified as Libinput
import River.Rhine.Policy qualified as Policy
import System.Process (spawnCommand)
import Prelude

main :: IO ()
main = App.main config

config :: Config
config =
  def
    { terminal = "ghostty"
    , border =
        Border
          { width = 2
          , active = Colour.hex 0xcba6f7
          , inactive = Colour.hex 0x202020
          }
    , bindings = KeyBindings.table
    , floatingApps = [FloatRule "regisseur" $ Just pickerPlacement]
    , ppLayout = ppLayoutOverride
    , helpViewer = Just $ Help.pipe "regisseur --mode help"
    , libinput =
        Libinput.defaultSettings
          { Libinput.tap = Just True
          , Libinput.tapButtonMap = Just Libinput.TapLeftRightMiddle
          }
    , startup = void $ spawnCommand "nextcloud-wrapper"
    , layouts = Layout.tall :| extraLayouts
    }
  where
    pickerPlacement =
      Policy.Placement
        { Policy.widthFraction = 1 / 2
        , Policy.heightFraction = 4 / 5
        , Policy.rightInset = 20
        , Policy.bottomInset = 50
        }

    threeColMid = Layout.threeColMid 1 (3 / 100) (3 / 7)

    extraLayouts =
      [ Transform.reflectHoriz Layout.tall
      , Layout.scroll
      , Transform.magnifier $ Transform.reflectHoriz Layout.tall
      , Transform.mirror Layout.tall
      , Transform.magnifier $ Transform.mirror Layout.tall
      , Layout.full
      , threeColMid
      , Transform.magnifier threeColMid
      , Transform.magnifier Layout.tall
      ]

ppLayoutOverride :: Text -> Text
ppLayoutOverride = \case
  "Tall" -> "|-|"
  "Mirror Tall" -> "|-.-|"
  "ReflectX Tall" -> "|-| |"
  "Magnifier Tall" -> "|-|" <> magnifier <> "|"
  "Magnifier Mirror Tall" -> "|" <> magnifier <> ".-|"
  "ThreeColMid" -> "|-| |-|"
  "Magnifier ThreeColMid" -> "|-|" <> magnifier <> "|-|"
  "Full" -> "| |"
  "Scroll" -> "|\8596|"
  name -> name
  where
    magnifier :: Text
    magnifier = "\983881"
