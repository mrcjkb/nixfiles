{-# LANGUAGE ScopedTypeVariables #-}

module Xmobar.Config (mkConfig) where

import Xmobar
import Xmobar.Plugin.Profile
import Xmobar.Plugin.VolumeBar

mkConfig :: IO Config
mkConfig = do
  (profileTemplate, profile) <- mkProfile
  pure $
    defaultConfig
      { -- appearance
        font = "JetBrains Mono Nerd Font Mono Bold 14"
      , bgColor = "#202020"
      , fgColor = "#cdd6f4"
      , position = TopH 30
      , -- , border =       BottomB
        -- , borderWidth = 0
        -- , borderColor =  "#cba6f7"

        -- layout
        sepChar = "%" -- delineator between plugin names and straight text
      , alignSep = "}{" -- separator between left-right alignment
      , template =
          " <fc=#89b4fa>\62227</fc> \57533 <fc=#cba6f7>\59255</fc> \57533 %XMonadLog% \57533 }{ %battery%"
            <> profileTemplate
            <> "\57533 %date% \57533 %volbar% \57533 %memory% \57533 %dynnetwork% \57533 %LSZH% "
      , -- , template =
        --     " \62227 \57533 \59255 \57533 %XMonadLog% \57533 }{ %battery%"
        --       <> "\57533 %date% \57533 %volbar% \57533 %memory% \57533 %dynnetwork% \57533 %LSZH% "
        -- general behavior
        lowerOnStart = True -- send to bottom of window stack on start
      , hideOnStart = False -- start with window unmapped (hidden)
      , allDesktops = True -- show on all desktops
      , overrideRedirect = True -- set the Override Redirect flag (Xlib)
      , pickBroadest = False -- choose widest display (multi-monitor)
      , persistent = True -- enable/disable hiding (True = disabled)
      -- plugins
      --   Numbers can be automatically colored according to their value. xmobar
      --   decides color based on a three-tier/two-cutoff system, controlled by
      --   command options:
      --     --Low sets the low cutoff
      --     --High sets the high cutoff
      --
      --     --low sets the color below --Low cutoff
      --     --normal sets the color between --Low and --High cutoffs
      --     --High sets the color above --High cutoff
      --
      --   The --template option controls how the plugin is displayed. Text
      --   color can be set by enclosing in <fc></fc> tags. For more details
      --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
      , commands =
          -- weather monitor
          [ Run $
              Weather
                "LSZH"
                [ "--template"
                , "<fc=#f9e2af><tempC> °C</fc> <skyCondition> <fc=#89b4fa><rh> \58227</fc>" -- 
                ]
                36000
          , -- XMonad logs
            Run XMonadLog
          , -- network activity monitor (dynamic interface resolution)
            Run $
              DynNetwork
                [ "--template"
                , "<dev>: \60065<tx> kB/s \60058<rx> kB/s" --  
                , "--Low"
                , "1000" -- units: B/s
                , "--High"
                , "5000" -- units: B/s
                , "--low"
                , okColour
                , "--normal"
                , warnColour
                , "--high"
                , criticalColour
                ]
                10
          , -- memory usage monitor
            Run $
              Memory
                [ "--template"
                , "\983899 <usedratio> %" -- 󰍛
                , "--Low"
                , "20" -- units: %
                , "--High"
                , "90" -- units: %
                , "--low"
                , okColour
                , "--normal"
                , warnColour
                , "--high"
                , criticalColour
                ]
                10
          , -- battery monitor
            Run $
              Battery
                [ "--template"
                , "<acstatus>"
                , "--Low"
                , "10" -- units: %
                , "--High"
                , "80" -- units: %
                , "--low"
                , criticalColour
                , "--normal"
                , warnColour
                , "--high"
                , okColour
                , "--" -- battery specific options
                -- discharging status 󰁿
                , "-o"
                , "\983167 <left>% (<timeleft>)"
                , -- AC "on" status, charging 󰂄
                  "-O"
                , "<fc=" <> warnColour <> ">\983172</fc>"
                , -- charged status 󰁹
                  "-i"
                , "<fc=" <> okColour <> ">\983161</fc>"
                ]
                50
          , Run profile
          , -- time and date indicator
            --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
            Run $ Date "<fc=#cdd6f4>%F (%a) %T</fc>" "date" 10
          , Run VolumeBar
          -- , -- keyboard layout indicator %kbd%
          --   Run $
          --     Kbd
          --       [ ("us(altgr-intl)", "<fc=" <> okColour <> ">US(altgr-intl)</fc>")
          --       , ("de(ch)", "<fc=" <> warnColour <> ">DE_CH</fc>")
          --       ]
          ]
      }
  where
    criticalColour = "#f38ba8"
    warnColour = "#f9e2af"
    okColour = "#cba6f7"
