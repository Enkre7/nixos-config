# My personnal NixOS config
With Flakes, Home-manager, Lanzaboot, nixos-hardware, nh (nix-helper), impermanence (in test) and Sops-nix (also in test).
Contain also a custom minimal ISO of nixos to facilitate installation via predefined aliases.

## Components
|                          | Promethium                         | Zirconium                          |
|--------------------------|------------------------------------|------------------------------------|
| **Hardware**             | Framework Laptop 13" AMD           | Custom tower                       |
| **Hardware**             | BTRFS Pool                         | BTRFS Pool                         |
| **Secure boot**          | Lanzaboot                          | Lanzaboot                          |
| **Kernel**               | Zen Linux                          | Linux                              |
| **Window Manager**       | Hyprland                           | Hyprland                           |
| **Display Manager**      | GDM                                | GDM                                |
| **Bar**                  | Waybar                             | Waybar                             |
| **Notification Daemon**  | Mako                               | Mako                               |
| **Shell**                | ZSH                                | ZSH                                |
| **Terminal**             | Kitty                              | Kitty                              |
| **Keyring Manager**      | Gnome Keyring                      | Gnome Keyring                      |
| **Application Launcher** | Wofi                               | Wofi                               |
| **Code Editor**          | VSCodium                           | VSCodium                           |
| **Text Editor**          | LibreOffice                        | LibreOffice                        |
| **Media Player**         | mpv                                | mpv                                |
| **Browser**              | Firefox                            | Firefox                            |
| **File Manager**         | LF + Thunar                        | LF + Thunar                        |
| **Games**                | Steam + Prism Launcher (Minecraft) | Steam + Prism Launcher (Minecraft) |
| **Screenshot Software**  | Swappy + Grim                      | Swappy + Grim                      |
| **Styling**              | Stylix                             | Stylix                             |
| **Font**                 | NerdFonts (JetBrainsMono)          | NerdFonts (JetBrainsMono)          |
| **Cursor**               | Bibata cursors (Bibata-Modern-Ice) | Bibata cursors (Bibata-Modern-Ice) |

## Images:
![alt text](https://github.com/Enkre7/nixos-config/blob/main/images/zirconium_1.png)
![alt text](https://github.com/Enkre7/nixos-config/blob/main/images/promethium_1.png)
![alt text](https://github.com/Enkre7/nixos-config/blob/main/images/promethium_2.png)
![alt text](https://github.com/Enkre7/nixos-config/blob/main/images/promethium_3.png)

## Installation:
You need to boot the minimal nixos iso after it's creation (See the [Build_custom_ISO.md](Build_custom_ISO.md) file).

_Set keyboard language: ```sudo loadkeys {{any_ISO3166-1_code}}```_

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
***To use the fingerprint sensor:*** ```sudo fprintd-enroll $USER && fprintd-verify```

***To use lanzaboot:***
  - Map lanzaboot.nix in the config.nix file
  - Rebuild configuration to enable ```sbctl``` command
  - ```sudo sbctl create-keys```
  - Rebuild configuration another time to enable secure in the OS
  - Reboot and erase precedent boot settings in BIOS
  - ```sudo sbctl enroll-keys --microsoft```
  - Reboot and force secureboot in BIOS
  -  ```bootctl status```

***To use impermanence:***
  - Map impermanence.nix in the config.nix file
  - Map impermanence.nix in the home.nix file (if using home-manager)
  - Rebuild configuration

***To use git:***
  - Copy the public and private ssh keys in ~/.ssh
  - Reload the sshd service
  - ```git remote set-url origin git@github.com:Enkre7/nixos-config.git``` in nixos directory

***To use Yubikey:***
  - Map yubikey.nix in the config.nix file 
  - nix-shell -p pam_u2f
  - mkdir -p ~/.config/Yubico
  - pamu2fcfg > ~/.config/Yubico/u2f_keys
    
  To test: 
    - nix-shell -p pamtester
    - pamtester login $USER authenticate
    - pamtester sudo $USER authenticate
