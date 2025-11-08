{ config, pkgs, inputs, lib, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://lanzaboote.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "lanzaboote.cachix.org-1:Nt8f5XMgn5LnvLPiJWKI5h7wtS7xwY6LyflCtlKHPeY="
      ];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      keep-going = true;
      warn-dirty = false;
    };
    optimise.automatic = true;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = config.stateVersion;
  documentation.doc.enable = false;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = config.flakePath;
  };

  environment.systemPackages = with pkgs; [
    nixd
    nixfmt-rfc-style
  ];
}
