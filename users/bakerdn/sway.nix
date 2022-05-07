{ pkgs, lib, config, ... }:

{
  wayland.windowManager.sway.enable = true;
  wayland.windowManager.sway.wrapperFeatures.gtk = true;
  wayland.windowManager.sway.config.modifier = "Mod4";
  wayland.windowManager.sway.config.terminal = "${pkgs.kitty}/bin/kitty";
  wayland.windowManager.sway.config.bars = [{ command = "${config.programs.waybar.package}/bin/waybar"; }];

  wayland.windowManager.sway.config.keybindings =
  let
    mod = config.wayland.windowManager.sway.config.modifier;
  in
  lib.mkOptionDefault
  {
    "${mod}+d" = "exec wofi --show drun";
  };
}
