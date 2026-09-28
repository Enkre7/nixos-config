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

## Secrets

Personal values (user, email, URLs, password hash, paths) live in the private repository `Enkre7/nixos-secrets`, used as the `secrets` flake input. See [CONFIGURATION.md](CONFIGURATION.md) and `secrets.example.nix`.

To update a value:

```bash
cd ~/nixos-secrets
$EDITOR secrets.nix
git commit -am "Update secrets" && git push

cd /etc/nixos
nix flake update secrets
nh os switch
git commit -am "flake.lock: update secrets" && git push
```

## Documentation

- **[BUILD_CUSTOM_ISO.md](BUILD_CUSTOM_ISO.md)** - Custom ISO creation
- **[INSTALL.md](INSTALL.md)** - Installation guide
- **[POST-INSTALL.md](POST-INSTALL.md)** - Post-installation setup
- **[CONFIGURATION.md](CONFIGURATION.md)** - Configuration guide
