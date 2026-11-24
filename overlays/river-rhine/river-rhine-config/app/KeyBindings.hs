module KeyBindings (table) where

import River.Rhine.Config (Config)
import River.Rhine.Config qualified as Config
import River.Rhine.Keybinding ((-->), (<+>))
import River.Rhine.Keybinding qualified as Keybinding
import River.Rhine.Keybinding.Binding (Binding, withDescription)
import River.Rhine.Keybinding.Modifier (Modifier (..))
import River.Rhine.Policy qualified as Policy
import River.Rhine.Wm (Command (..))
import Prelude

table :: Config -> [Binding]
table config = Config.defaultBindings config <> custom
  where
    custom =
      [ withDescription "Launch a program" $
          Super <+> Keybinding.kO --> [Spawn "regisseur --mode drun"]
      , withDescription "Reload the bar" $
          Super <+> Keybinding.kQ --> [Spawn reloadBar]
      , withDescription "Run a command" $
          Super <+> Shift <+> Keybinding.kO --> [Spawn "regisseur --mode run"]
      , withDescription "Power menu" $
          Super <+> Shift <+> Keybinding.kQ --> [Spawn "regisseur --mode power"]
      , withDescription "Clipboard history" $
          Super <+> Keybinding.kC --> [Spawn "cliphist list | regisseur --mode stdin | cliphist decode | wl-copy"]
      , withDescription "Paste the primary selection" $
          Super <+> Keybinding.kV --> [Spawn pasteSelection]
      , withDescription "Screenshot a region" $
          Keybinding.printScreen --> [Spawn screenshotSelection]
      , withDescription "Screenshot the screen" $
          Super <+> Keybinding.printScreen --> [Spawn screenshotScreen]
      , withDescription "Search Hoogle (ners)" $
          Super <+> Alt <+> Keybinding.kH --> [Spawn "regisseur --mode search --engine hoogle.ners"]
      , withDescription "Search Hoogle (IDA)" $
          Super <+> Alt <+> Keybinding.kI --> [Spawn "regisseur --mode search --engine hoogle.ida"]
      , withDescription "Toggle fullscreen" $
          Super <+> Keybinding.kF --> [Apply Policy.ToggleFullscreen]
      , withDescription "Sink the window" $
          Super <+> Keybinding.kT --> [Apply Policy.Sink]
      , withDescription "Play or pause" $
          Keybinding.audioPlay --> [Spawn "playerctl play-pause"]
      , withDescription "Previous track" $
          Keybinding.audioPrevious --> [Spawn "playerctl previous"]
      , withDescription "Next track" $
          Keybinding.audioNext --> [Spawn "playerctl next"]
      , withDescription "Raise the volume" $
          Keybinding.audioRaiseVolume --> [Spawn volumeUp]
      , withDescription "Lower the volume" $
          Keybinding.audioLowerVolume --> [Spawn volumeDown]
      , withDescription "Mute the volume" $
          Keybinding.audioMute --> [Spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"]
      , withDescription "Raise the brightness" $
          Keybinding.brightnessUp --> [Spawn "brightnessctl set +10%"]
      , withDescription "Lower the brightness" $
          Keybinding.brightnessDown --> [Spawn "brightnessctl set 10%-"]
      , withDescription "Terminal with tmux" $
          Super <+> Shift <+> Keybinding.kA --> [Spawn "ghostty -e tmux"]
      , withDescription "File manager" $
          Super <+> Shift <+> Keybinding.kN --> [Spawn "ghostty -e yazi"]
      , withDescription "Browser" $
          Super <+> Shift <+> Keybinding.kB --> [Spawn "zen"]
      , withDescription "Keyboard layout card" $
          Super <+> Alt <+> Keybinding.kK --> [Spawn layoutCard]
      , withDescription "Warpd normal mode" $
          Super <+> Keybinding.kM --> [Spawn "warpd --normal"]
      , withDescription "Warpd hint mode" $
          Super <+> Shift <+> Keybinding.kM --> [Spawn "warpd --hint2"]
      , withDescription "Bluetooth manager" $
          Super <+> Alt <+> Keybinding.kB --> [Spawn "blueman-manager"]
      , withDescription "Volume control" $
          Super <+> Alt <+> Keybinding.kV --> [Spawn "pavucontrol"]
      , withDescription "Inkscape" $
          Super <+> Shift <+> Keybinding.kI --> [Spawn "inkscape"]
      , withDescription "Yubico Authenticator" $
          Super <+> Shift <+> Keybinding.kY --> [Spawn "yubioath-flutter"]
      , withDescription "Lock the session" $
          Super <+> Shift <+> Keybinding.kL --> [Spawn "systemctl start concierge-$(id -un).service"]
      ]

    reloadBar :: String
    reloadBar =
      "pkill -x rhinebar-config; setsid rhinebar-config >/tmp/rhinebar.log 2>&1 </dev/null &"

    pasteSelection :: String
    pasteSelection =
      "wl-paste --primary | wl-copy && wtype -M shift -k Insert -m shift"

    screenshotSelection :: String
    screenshotSelection =
      "grim -g \"$(slurp)\" - | satty -f - -o \"/tmp/screenshot-$(date +%s).png\""
        <> " --copy-command wl-copy --actions-on-enter save-to-clipboard --save-after-copy"

    screenshotScreen :: String
    screenshotScreen =
      "grim - | satty -f - -o \"/tmp/screenshot-$(date +%s).png\""
        <> " --copy-command wl-copy --actions-on-enter save-to-clipboard --save-after-copy"

    layoutCard :: String
    layoutCard =
      "inkview $HOME/git/github/mrcjkb/keyboardio-atreus-firmware/"
        <> "atreus-layout-card.svg"

    volumeUp :: String
    volumeUp = "pactl set-sink-volume @DEFAULT_SINK@ +5%"

    volumeDown :: String
    volumeDown = "pactl set-sink-volume @DEFAULT_SINK@ -5%"
