# Installation Guide

## Prerequisites

#### You need the NixOS custom ISO to proceed:
See [BUILD_CUSTOM_ISO.md](BUILD_CUSTOM_ISO.md)

## 0. Keyboard layout
Boot the NixOS ISO and set keyboard layout:
```bash
sudo loadkeys fr
```

## 1. Network Setup

**Ethernet:** Plug cable

**WiFi:**
```bash
read -p "Interface: " INTERFACE
read -p "SSID: " WIFI_SSID
read -p "Password: " WIFI_PASSWORD
wpa_passphrase "$WIFI_SSID" "$WIFI_PASSWORD" | sudo wpa_supplicant -B -i $INTERFACE -c /dev/stdin
```

## 2. Clone Repository

```bash
nix-shell -p git --command "git clone https://github.com/Enkre7/nixos-config /tmp/nixos"
```

## 3. Partition Disk

⚠️ **This ERASES ALL DATA!**

Identify disk:
```bash
lsblk
```

### Standard Installation (disko.nix)

Persistent root - recommended for most users.

```bash
read -p "Disk name (e.g., nvme0n1): " DISKNAME
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko /tmp/nixos/tools/disko.nix \
  --argstr device "/dev/$DISKNAME"
```

**Subvolumes:** `/`, `/home`, `/nix`, `/var/log`, `/.snapshots`

### Impermanence Installation (disko-persist.nix)

Ephemeral root - wiped on each boot.

```bash
read -p "Disk name (e.g., nvme0n1): " DISKNAME
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko /tmp/nixos/tools/disko-persist.nix \
  --argstr device "/dev/$DISKNAME"
```

**Subvolumes:** `/`, `/persist`, `/nix`, `/var/log`, `/.snapshots`

## 4. Copy Configuration

**Standard:**
```bash
sudo mkdir -p /mnt/etc
sudo cp -r /tmp/nixos /mnt/etc/nixos
```

**Impermanence:**
```bash
sudo mkdir -p /mnt/persist/system /mnt/persist/home
sudo cp -r /tmp/nixos /mnt/persist/system/
```

## 5. Install

```bash
read -p "Hostname (zirconium/promethium): " HOSTNAME
read -p "Username: " USERNAME
```

**Standard:**
```bash
sudo nixos-install --flake /mnt/etc/nixos#$HOSTNAME
sudo nixos-enter --root /mnt -c "passwd $USERNAME"
```

**Impermanence:**
```bash
sudo nixos-install --flake /mnt/persist/system/nixos#$HOSTNAME
sudo nixos-enter --root /mnt -c "passwd $USERNAME"
```

## 6. Reboot

```bash
sudo reboot
```

## Next Steps

See [POST-INSTALL.md](POST-INSTALL.md) for post-installation configuration.
