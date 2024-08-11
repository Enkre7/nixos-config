# My personnal NixOS config
With Flakes, Home-manager, Lanzaboot, nixos-hardware and nh (nix-helper).

## Components
|                          | Promethium (🚧in build)            | Zirconium (🚧in build)            |
|--------------------------|------------------------------------|------------------------------------|
| **Hardware**             | Framework Laptop 13" AMD           | Custom tower                       |
| **Hardware**             | BTRFS Pool                         | BTRFS Pool                         |
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
You need to boot the minimal nixos iso.

_Set keyboard language: ```sudo loadkeys LANGUAGE_ISO3166-1```_

***1. Setup network:***

- A - Use an ethenet cable
- B - Setup a wifi interface:
  - ```ifconfig``` to list the disponibles interfaces (ex: wlp1s0)
  - ```bash
    read -p "Enter wifi interface: " INTERFACE
    read -p "Enter wifi SSID: " WIFI_SSID
    read -p "Enter wifi password: " WIFI_PASSWORD
    wpa_passphrase '$WIFI_SSID' '$WIFI_PASSWORD' | sudo wpa_supplicant -B -i $INTERFACE -c /dev/stdin
    ```

***2. Clone the git repository:***
```nix-shell -p git --command "git clone https://github.com/Enkre7/nixos-config /tmp/nixos"```

***3. Disk partitionning and volumes creation with Disko:***
- ```lsblk``` to find the disk path
- ```read -p "Enter DISKNAME to format: " DISKNAME```
- ```nix
  sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko /tmp/nixos/tools/disko.nix \
  --arg device '"/dev/$DISKNAME"'
  ```
- ```lsblk /dev/$DISKNAME --fs``` to show disk formated with filesystem

***4. Create needed missing folders and move the config:***
```bash
sudo mkdir -p /mnt/persist/system
sudo mkdir -p /mnt/persist/home
sudo cp -r /tmp/nixos /mnt/persist/system/
```
***5. Install nixos:***
```bash
read -p "Enter flake's config hostname: " HOSTNAME
read -p "Enter username: " USERNAME
nix-shell -p git --command "sudo nixos-install --flake /mnt/persist/system/nixos#$HOSTNAME"
passwd $USERNAME
```
_Ask for password twice, first is for root second for specified user._

## After installation:
### Setup the config on the machine
***To use the fingerprint sensor:*** ```sudo fprintd-enroll USERNAME && fprintd-verify```

***To use lanzaboot:***
  - ```sudo sbctl create-keys```
  - Uncomment lanzaboot.nix in /nixos/host/HOSTNAME/config/default.nix
  - Rebuild configuration
  - ```sudo sbctl enroll-keys --microsoft```
  - reboot
  -  ```bootctl status```

***To use impermanence:***
  - Uncomment impermanence.nix in /nixos/host/HOSTNAME/config/default.nix
  - Uncomment also impermanence.nix in /nixos/host/HOSTNAME/home/default.nix
  - Rebuild configuration
