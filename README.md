# My personnal NixOS config
With Flakes, Home-manager, Lanzaboot, nixos-hardware and nh (nix-helper).

## Components
|                          | Promethium                         | Zirconium                          |
|--------------------------|------------------------------------|------------------------------------|
| **Hardware**             | Framework Laptop 13" AMD           | Custom tower                       |
| **Hardware**             | BTRFS Pool                          | BTRFS Pool                         |
| **Secure boot**          | Lanzaboot                          | Lanzaboot                          |
| **Kernel**               | Zen Linux                          | Linux                              |
| **Window Manager**       | Hyprland                           | Hyprland                           |
| **Display Manager**      | GDM                                | GDM                                |
| **Bar**                  | Waybar                             | Waybar                             |
| **Notification Daemon**  | Mako                               | Mako                               |
| **Shell**                | Bash                               | Bash                               |
| **Terminal**             | Kitty                              | Kitty                              |
| **Keyring Manager**      | Gnome Keyring                      | Gnome Keyring                      |
| **Application Launcher** | Wofi                               | Wofi                               |
| **Code Editor**          | VSCodium                           | VSCodium                           |
| **Text Editor**          | LibreOffice                        | LibreOffice                        |
| **Media Player**         | mpv                                | mpv                                |
| **Browser**              | Firefox                            | Firefox                            |
| **File Manager**         | Thunar                             | Thunar                             |
| **Games**                | Steam + Prism Launcher (Minecraft) | Steam + Prism Launcher (Minecraft) |
| **Screenshot Software**  | Swappy + Grim                      | Swappy + Grim                      |
| **Styling**              | Stylix                             | Stylix                             |
| **Font**                 | NerdFonts (JetBrainsMono)          | NerdFonts (JetBrainsMono)          |
| **Cursor**               | Bibata cursors (Bibata-Modern-Ice) | Bibata cursors (Bibata-Modern-Ice) |

## Installation:
### Temporary network setup:
  - ```add_network```
  - ```set_network 0 ssid "myhomenetwork"```
  - ```set_network 0 psk "mypassword"```
  - ```set_network 0 key_mgmt WPA-PSK```
  - ```enable_network 0```

### Volumes creation with Disko
- ```curl https://raw.githubusercontent.com/Enkre7/nixos-config/main/tools/disko.nix -o /tmp/disko.nix```
- ```lsblk``` to find the disk path
- ```nix
  sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko /tmp/disko.nix \
  --arg device '"/dev/DISKPATH"'
  ```
- ```lsblk``` to verify the partitioning

### Pull the config from Github
To sync the config from Github:
- Create a ssh key on your machine and add it on your Github account.
- Sync the repo with: ```git clone git@github.com:Enkre7/nixos-config.git```
- Add the remote git repo: ```git remote add github git@github.com:Enkre7/nixos-config.git```

## After installation:
### Setup the config on the machine
To use the fingerprint: ```sudo fprintd-enroll <user> & fprintd-verify```

To use lanzaboot: 
  - ```sudo sbctl create-keys```
  - ```sudo sbctl enroll-keys --microsoft```
  -  ```bootctl status```
