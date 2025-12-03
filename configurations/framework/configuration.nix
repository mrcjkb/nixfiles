{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./bluetooth.nix
    ./kmod.nix
  ];

  # adds amdgpu to kernelModules
  hardware = {
    amdgpu.initrd.enable = true;
    # Needed for desktop environments to detect/manage display brightness
    sensor.iio.enable = true;
    # Enable keyboard customization
    keyboard.qmk.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  networking = {
    hostName = "nixos-framework";
    # Disabled, because networking.useDHCP is set to true in hardware-configuration.nix
    # interfaces = {
    #   wlp1s0.useDHCP = lib.mkDefault true; # expansion bay module (no gpu)
    #   wlp4s0.useDHCP = lib.mkDefault true; # amdgpu module
    # };
  };

  services = {
    xserver.videoDrivers = [
      "amdgpu"
      "modesetting"
    ];
    # Firmware is updateable through fwupd
    fwupd.enable = true;

    udev.extraRules = ''
      # Ethernet expansion card support
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"

      # Allow access to the keyboard modules for programming, for example by
      # visiting https://keyboard.frame.work with a WebHID-compatible browser.
      #
      # https://community.frame.work/t/responded-help-configuring-fw16-keyboard-with-via/47176/5
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';

    # ssd trimming
    fstrim.enable = true;
  };

  boot = {
    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-uuid/bd2abb25-4ceb-4f75-8868-71581bfbb52d";
      };
    };
    tmp = {
      useTmpfs = true;
      tmpfsSize = "14G";
    };
    loader = {
      grub = {
        enable = true;
        enableCryptodisk = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelParams =
      [
        # There seems to be an issue with panel self-refresh (PSR) that
        # causes hangs for users.
        #
        # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
        # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
        "amdgpu.dcdebugmask=0x10"
      ]
      # Workaround for SuspendThenHibernate: https://lore.kernel.org/linux-kernel/20231106162310.85711-1-mario.limonciello@amd.com/
      ++ lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") [
        "rtc_cmos.use_acpi_alarm=1"
      ];
  };

  environment = {
    systemPackages = with pkgs; [
      framework-tool
    ];

    # Allow `services.libinput.touchpad.disableWhileTyping` to work correctly.
    # Set unconditionally because libinput can also be configured dynamically via
    # gsettings.
    #
    # This is extracted from the quirks file that is in the upstream libinput
    # source.  Once we can assume everyone is on at least libinput 1.26.0, this
    # local override file can be removed.
    # https://gitlab.freedesktop.org/libinput/libinput/-/commit/566857bd98131009699c9ab6efc7af37afd43fd0
    etc."libinput/local-overrides.quirks".text = ''
      [Framework Laptop 16 Keyboard Module]
      MatchName=Framework Laptop 16 Keyboard Module*
      MatchUdevType=keyboard
      MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
      AttrKeyboardIntegration=internal

      [Framework Laptop 16 Keyboard Module - ANSI]
      MatchName=Framework Laptop 16 Keyboard Module*
      MatchUdevType=keyboard
      MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
      AttrKeyboardIntegration=internal
    '';
  };

  home-manager = {
    users.mrcjk = {
      home.stateVersion = config.system.stateVersion;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "25.05"; # Did you read the comment?
  };
}
