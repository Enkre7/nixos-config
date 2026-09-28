# Installation Guide

## Prerequisites

You need the NixOS custom ISO. See [BUILD_CUSTOM_ISO.md](BUILD_CUSTOM_ISO.md)

## Installation Steps

### 1. Boot ISO

Boot from the custom ISO and set keyboard layout if needed:

```bash
sudo loadkeys fr
```

### 2. Network

**Ethernet:** Plug cable (automatic)

**WiFi:**
```bash
setup-wifi
```

### 3. Clone Repository

```bash
setup-repo
```

### 4. Partition Disk

⚠️ **This ERASES ALL DATA!**

```bash
setup-disk
```

Choose installation type and enter disk name (e.g., `nvme0n1`, `sda`)

### 5. Copy Configuration

```bash
setup-dir
```

### 6. Edit Configuration

**Standard installation:**
```bash
nano /mnt/etc/nixos/hosts/[hostname]/variables.nix
```

Set:
```nix
flakePath = "/etc/nixos";
dotfilesPath = "/etc/nixos/dotfiles";
```

Comment out impermanence imports in `config.nix`, `home.nix`, and `flake.nix`

**Impermanence installation:**
```bash
nano /mnt/persist/system/nixos/hosts/[hostname]/variables.nix
```

Set:
```nix
flakePath = "/persist/system/nixos";
dotfilesPath = "/persist/system/nixos/dotfiles";
```

Uncomment impermanence imports in `config.nix`, `home.nix`, and `flake.nix`

### 7. Provide Secrets

The ISO has no SSH key, so the private `secrets` input cannot be fetched over SSH. Clone it over HTTPS:

```bash
setup-secrets
```

Username: your GitHub username. Password: a fine-grained personal access token (GitHub → Settings → Developer settings), read-only on `nixos-secrets`, with a short expiration. Revoke it after installation.

Fallback: copy `secrets.nix` manually (USB stick, Nextcloud...):

```bash
mkdir -p /tmp/nixos-secrets
cp /path/to/secrets.nix /tmp/nixos-secrets/
```

`setup-nixos` uses `/tmp/nixos-secrets` automatically when it exists.

### 8. Install

```bash
setup-nixos
```

Choose installation type, hostname (`zirconium` or `promethium`), and username.

### 9. Reboot

```bash
sudo reboot
```

## Quick Reference

```bash
setup-help       # Show all commands
setup-wifi       # Configure WiFi
setup-repo       # Clone repository
setup-secrets    # Clone private secrets (HTTPS + token)
setup-disk       # Partition disk
setup-dir        # Copy configuration
setup-nixos      # Install NixOS
```

## Installation Types

**Standard:** Persistent root (recommended)
- Subvolumes: `/`, `/home`, `/nix`, `/var/log`, `/.snapshots`

**Impermanence:** Ephemeral root (wiped on boot)
- Subvolumes: `/`, `/persist`, `/nix`, `/var/log`, `/.snapshots`

## Next Steps

After installation: [POST-INSTALL.md](POST-INSTALL.md)
