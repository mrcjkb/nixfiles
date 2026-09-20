{...}: {
  nixpkgs.overlays = [
    (_: super: {
      brave = super.brave.override {
        # Prevent brave from trying to use kwallet
        commandLineArgs = "--password-store=basic";
      };
    })
  ];
}
