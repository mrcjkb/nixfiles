{...}: {
  # Workaround for chrysalis not being able to talk to keyboard
  services.udev.extraRules = ''
    KERNEL=="ttyACM0", SUBSYSTEM=="tty", MODE="0666"
  '';
}
