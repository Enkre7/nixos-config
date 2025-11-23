# My Personal NixOS Config

NixOS configuration with Flakes, Home-manager, Lanzaboot, nixos-hardware, nh, impermanence (optional), and Sops-nix.

## Components

|                          | Promethium                         | Zirconium                          |
|--------------------------|------------------------------------|------------------------------------|
| **Hardware**             | Framework Laptop 13" AMD           | Custom tower                       |
| **Storage**              | BTRFS on LVM                       | BTRFS on LVM                       |
| **Secure Boot**          | Lanzaboot                          | Lanzaboot                          |
| **Kernel**               | Linux Latest                       | Linux Latest                       |
| **Window Manager**       | Hyprland                           | Hyprland                           |
| **Display Manager**      | Greetd + TUIGreet                  | Greetd + TUIGreet                  |
| **Bar**                  | Waybar                             | Waybar                             |
| **Notification Daemon**  | SwayNC                             | SwayNC                             |
| **Shell**                | ZSH                                | ZSH                                |
| **Terminal**             | Kitty                              | Kitty                              |
| **Keyring Manager**      | Gnome Keyring                      | Gnome Keyring                      |
| **Application Launcher** | Rofi                               | Rofi / Wofi                        |
| **Lock Screen**          | Hyprlock                           | Hyprlock                           |
| **Code Editor**          | VSCodium                           | VSCodium                           |
| **Office Suite**         | OnlyOffice                         | OnlyOffice                         |
| **Media Player**         | mpv                                | mpv                                |
| **Browser**              | Firefox                            | Firefox                            |
| **File Manager**         | LF + Thunar                        | LF + Thunar                        |
| **Games**                | Steam + Prism Launcher (Minecraft) | Steam + Prism Launcher (Minecraft) |
| **Screenshot Software**  | Swappy + Grim                      | Swappy + Grim                      |
| **Styling**              | Stylix                             | Stylix                             |
| **Font**                 | NerdFonts (JetBrainsMono)          | NerdFonts (JetBrainsMono)          |
| **Cursor**               | Bibata cursors (Bibata-Modern-Ice) | Bibata cursors (Bibata-Modern-Ice) |

## Documentation

- **[INSTALL.md](INSTALL.md)** - Installation guide
- **[POST-INSTALL.md](POST-INSTALL.md)** - Post-installation setup
- **[CONFIGURATION.md](CONFIGURATION.md)** - Configuration guide
- **[Build_custom_ISO.md](Build_custom_ISO.md)** - Custom ISO creation

## Quick Start

### Standard Installation (Persistent root)
```bash
sudo nix run github:nix-community/disko -- --mode disko ./tools/disko.nix --argstr device "/dev/sdX"
```

### Impermanence Installation (Ephemeral root)
```bash
sudo nix run github:nix-community/disko -- --mode disko ./tools/disko-persist.nix --argstr device "/dev/sdX"
```

See [INSTALL.md](INSTALL.md) for complete instructions.
