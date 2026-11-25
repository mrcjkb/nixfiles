module Main where

import Control.Exception (IOException, displayException, try)
import Control.Monad (unless, void)
import Data.Default (def)
import Data.List.NonEmpty (NonEmpty (..))
import Data.Map.Strict qualified as Map
import Data.Text (Text)
import KeyBindings qualified
import River.Rhine.App qualified as App
import River.Rhine.Appearance.Border (Border (..))
import River.Rhine.Appearance.Colour qualified as Colour
import River.Rhine.Config (Config (..), FloatRule (..), Screen (..))
import River.Rhine.Help qualified as Help
import River.Rhine.Layout qualified as Layout
import River.Rhine.Layout.Transform qualified as Transform
import River.Rhine.Libinput qualified as Libinput
import River.Rhine.Policy qualified as Policy
import System.Posix.Process (executeFile)
import System.Process (spawnCommand)
import Prelude

main :: IO ()
main = App.start config reload

reload :: IO (Either String ())
reload = do
  executed <- try @IOException $ executeFile binary False [] Nothing
  pure $ case executed of
    Left problem -> Left $ "river-rhine: could not reload: " <> displayException problem
    Right () -> Right ()
  where
    binary = "/run/current-system/sw/bin/river-rhine-config"

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
    , startup = do
        reloaded <- App.reloaded
        unless reloaded do
          void $ spawnCommand "nextcloud-wrapper"
          void $ spawnCommand "stylix-wallpaper"
    , layouts = defaultLayouts
    , outputLayouts =
        Map.fromList
          [ (W, wLayouts)
          , (E, eLayouts)
          ]
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

    defaultLayouts = Layout.tall :| Layout.scroll : extraLayouts

    wLayouts = Layout.scroll :| Layout.tall : extraLayouts

    eLayouts = Layout.tall :| [Layout.full, threeColMid]

    extraLayouts =
      [ Transform.reflectHoriz Layout.tall
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
