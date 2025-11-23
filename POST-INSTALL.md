# Post-Installation Guide

## Essential Setup

### Configure flakePath

Edit `hosts/[hostname]/variables.nix`:

**Standard:**
```nix
flakePath = "/etc/nixos";
```

**Impermanence:**
```nix
flakePath = "/persist/system/nixos";
```

This configures all aliases and paths automatically.

### Setup Git

```bash
# Copy SSH keys
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub

# Configure remote (use your flakePath)
cd /etc/nixos  # or /persist/system/nixos
git remote set-url origin git@github.com:Enkre7/nixos-config.git
```

## Optional Setup

### Secure Boot (Lanzaboot)

```bash
sudo sbctl create-keys
sudo nixos-rebuild switch
sudo reboot  # Delete old keys in BIOS
sudo sbctl enroll-keys --microsoft
sudo reboot  # Enable Secure Boot in BIOS
```

### Yubikey Authentication

```bash
mkdir -p ~/.config/Yubico
pamu2fcfg > ~/.config/Yubico/u2f_keys
```

### Fingerprint (Framework Laptop)

```bash
sudo fprintd-enroll $USER
fprintd-verify
```

## Impermanence Only

For impermanence installation, uncomment these imports:

**In `config.nix`:**
```nix
../../configModules/impermanence.nix
```

**In `home.nix`:**
```nix
../../homeModules/impermanence.nix
```

**In `flake.nix`:**
```nix
inputs.impermanence.nixosModules.impermanence
```

Then rebuild:
```bash
sudo nixos-rebuild switch
```

## Verify Installation

```bash
# Check mount points
lsblk -f

# Verify Secure Boot (if enabled)
sudo sbctl status

# Test rebuild alias
rebuild
```
