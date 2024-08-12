{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Zircoonium";
  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  console.keyMap = "fr";

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    videoDrivers = ["nvidia"];
    xkb.layout = "fr";
    xkb.variant = "";
    displayManager.gdm.enable = true;
  };
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "enkre";
  hardware.nvidia.modesetting.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    image = /home/enkre/Wallpapers/everforest-circuit_closeup.png;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    fonts = {
      monospace.package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
      monospace.name = "JetbrainsMono Nerd Font Mono";
      sansSerif.package = pkgs.dejavu_fonts;
      sansSerif.name = "DejaVu Sans";
      serif.package = pkgs.dejavu_fonts;
      serif.name = "DejaVu Serif";
    };
    polarity = "dark";
    opacity = {
      applications = 1.0;
      terminal = 0.7;
      desktop = 1.0;
      popups = 0.9;
    };
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.enkre = {
    isNormalUser = true;
    description = "enkre";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."enkre" = import ./home.nix;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty
    fastfetch
    git
    curl
    sl
    mangohud
    vlc
  ];

 system.stateVersion = "23.11";
}
