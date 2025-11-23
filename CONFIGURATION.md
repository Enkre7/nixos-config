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

## Variables Template

Edit `hosts/[hostname]/variables.nix`:

```nix
config = {
  stateVersion = "25.05";
  hostname = "zirconium";
  user = "enkre";
  
  # Set based on installation type
  flakePath = "/etc/nixos";  # or "/persist/system/nixos"
  dotfilesPath = "${config.flakePath}/dotfiles";
  
  # Styling
  wallpaper = "${config.dotfilesPath}/wallpapers/image.png";
  styleTheme = "everforest";
  stylePolarity = "dark";
  
  # Git
  gitUsername = "YourUsername";
  gitEmail = "your@email.com";
  
  # Services
  searxngURL = "searxng.example.com";
  firefoxSyncURL = "sync.example.com";
  
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
