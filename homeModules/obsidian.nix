{ config, lib, pkgs, ... }:

let
  cfg = config.obsidian;

  # Native Wayland drag and drop is broken in Obsidian's Electron under Hyprland:
  # moving a note in the file explorer leaves the drag stuck and the window frozen.
  # Run it through XWayland; force_zero_scaling makes X11 clients render at 1x,
  # so the HiDPI scale is passed to Electron explicitly.
  obsidian = pkgs.symlinkJoin {
    name = "obsidian-xwayland-${pkgs.obsidian.version}";
    paths = [ pkgs.obsidian ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/obsidian \
        --unset NIXOS_OZONE_WL \
        --add-flags "--ozone-platform=x11 --force-device-scale-factor=${cfg.scale}"
    '';
  };
in
{
  options.obsidian.scale = lib.mkOption {
    type = lib.types.str;
    default = "1";
    description = "Device scale factor for Obsidian under XWayland (match the main monitor scale).";
  };

  config.home.packages = [ obsidian ];
}
