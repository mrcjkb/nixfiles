{
  pkgs,
  lib,
  ...
}: {
  fonts = {
    fontDir.enable = lib.mkDefault true;
    enableGhostscriptFonts = lib.mkDefault true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      excalifont # Used by excalidraw
      figtree
      roboto
      lato # Font used in tiko presentations, etc.
      fira-sans
      fira-math
      font-awesome
      open-sans # Sa lek's CV
    ];
  };
}
