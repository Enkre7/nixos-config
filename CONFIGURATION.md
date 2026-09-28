# Configuration Guide

## Understanding flakePath

The `flakePath` variable in `variables.nix` controls all path-dependent configurations.

### Set Based on Installation Type

**Standard installation:**
```nix
flakePath = "/etc/nixos";
dotfilesPath = "/etc/nixos/dotfiles";
```

**Impermanence installation:**
```nix
flakePath = "/persist/system/nixos";
dotfilesPath = "/persist/system/nixos/dotfiles";
```

### What Uses flakePath

- Shell aliases (`rebuild`, `push`, `pull`, `update`)
- Git safe directories
- SSH key symlinks
- VSCode/VSCodium Nix language server
- Wallpaper and dotfiles paths

## Personal Values

Personal values (user, email, URLs, password hash, paths) are not stored in this repository. They come from the private flake input `secrets`, a repository containing a single `secrets.nix` file.

To use this configuration, create your own private repository from `secrets.example.nix` and point the `secrets` input of `flake.nix` to it.

## Variables Template

Edit `hosts/[hostname]/variables.nix` for host-specific values. Personal values are read from `secrets.nix` (see `secrets.example.nix`):

```nix
config = {
  stateVersion = "25.05";
  hostname = "zirconium";

  # Set based on installation type
  flakePath = "/etc/nixos";  # or "/persist/system/nixos"
  dotfilesPath = "${config.flakePath}/dotfiles";

  # Styling
  wallpaper = ../../dotfiles/wallpapers/dark/image.png;
  styleTheme = "everforest";
  stylePolarity = "dark";

  # Personal values from secrets.nix
  user = secrets.user;
  gitUsername = secrets.gitUsername;
  gitEmail = secrets.gitEmail;
  hashedPassword = secrets.hashedPassword;
  searxngURL = secrets.searxngURL;
  firefoxSyncURL = secrets.firefoxSyncURL;
  bitwardenURL = secrets.bitwardenURL;
  protonCalendarUrl = secrets.protonCalendarUrl;
  nextcloudPath = secrets.nextcloudPath;
  avatarPath = secrets.avatarPath;

  # Hardware
  isLaptop = false;
  cpuVendor = "AMD";
  isFrameworkDevice = false;
  kernelPackage = pkgs.linuxPackages_latest;
};
```

## Switching Installation Types

1. Backup data
2. Reinstall with different Disko configuration
3. Update `flakePath` in `variables.nix`
4. For impermanence: uncomment imports
5. For standard: comment out impermanence imports
6. Rebuild system

## Available Themes

See: https://github.com/tinted-theming/schemes

Examples: `everforest`, `gruvbox-dark`, `nord`, `catppuccin`, `tokyo-night`

## After Changing Variables

Always rebuild:
```bash
sudo nixos-rebuild switch
```

Or use the alias (after first rebuild):
```bash
rebuild
```
