{
  pkgs,
  lib,
  config,
  ...
}: {
  wayland.windowManager.sway.enable = true;
  wayland.windowManager.sway.wrapperFeatures.gtk = true;
  wayland.windowManager.sway.config.modifier = "Mod4";
  wayland.windowManager.sway.config.terminal = "${pkgs.kitty}/bin/kitty";
  wayland.windowManager.sway.config.bars = [
    {command = "${config.programs.waybar.package}/bin/waybar";}
  ];
  wayland.windowManager.sway.config.menu = "wofi --show drun";

  # gaps
  wayland.windowManager.sway.config.gaps.smartBorders = "on";
  wayland.windowManager.sway.config.gaps.smartGaps = false;
  wayland.windowManager.sway.config.gaps.inner = 12;
  wayland.windowManager.sway.config.gaps.outer = 4;

  wayland.windowManager.sway.config.keybindings = let
    mod = config.wayland.windowManager.sway.config.modifier;
  in
    lib.mkOptionDefault
    {
      "${mod}+y" = "border toggle";
      "${mod}+Tab" = "workspace back_and_forth";
    };
}
