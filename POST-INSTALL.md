# Post-Installation Guide

## 1. Essential Setup

### 1.1 Configure flakePath

Edit `hosts/[hostname]/variables.nix`:
```nix
# Standard installation
flakePath = "/etc/nixos";

# Impermanence installation
flakePath = "/persist/system/nixos";
```

### 1.2 Setup Git

Home Manager automatically generates SSH keys on first boot at `~/.ssh/github` and `~/.ssh/github.pub`. A notification will prompt you to add the key to GitHub.
```bash
# Display public key
cat ~/.ssh/github.pub

# Add to GitHub: Settings → SSH and GPG keys → New SSH key
# Configure remote (use your flakePath)
cd /etc/nixos  # or /persist/system/nixos
git remote set-url origin git@github.com:Enkre7/nixos-config.git

# Test connection
ssh -T git@github.com
```

**Note:** Permissions are set automatically. With impermanence, ensure SSH keys persist in `/persist/home/[user]/.ssh`.

---

## 2. Optional Setup

### 2.1 Secure Boot (Lanzaboot)

Lanzaboot enables Secure Boot on NixOS by automatically signing the kernel and initramfs. Secure Boot ensures only digitally signed software can boot, protecting against rootkits and malicious bootloaders.

**Prerequisites:**
- Lanzaboot enabled in configuration before installation
- `../../configModules/lanzaboote.nix` imported in `config.nix`
- UEFI system (not Legacy BIOS)

#### Setup Process

**Step 1: Create Secure Boot keys**
```bash
sudo sbctl create-keys
```
Generates PK, KEK, and db keys in `/etc/secureboot/`.

**Step 2: Rebuild system**
```bash
sudo nixos-rebuild switch
```
Automatically signs kernel, initramfs, and configures bootloader.

**Step 3: Clear old keys in BIOS**
```bash
sudo reboot
```
In BIOS/UEFI (F2/Del/F12):
- Navigate to Security → Secure Boot
- Select "Clear All Secure Boot Keys"
- Save and exit

**Step 4: Enroll your keys**
```bash
sudo sbctl enroll-keys --microsoft
```
Flag `--microsoft` keeps Microsoft keys for firmware compatibility and Windows dual-boot.

**Step 5: Enable Secure Boot**
```bash
sudo reboot
```
In BIOS/UEFI:
- Security → Secure Boot → Enabled
- Save and exit

#### Verification
```bash
sudo sbctl status
```

Expected output:
```
Installed:      ✓ sbctl is installed
Setup Mode:     ✓ Disabled
Secure Boot:    ✓ Enabled
Vendor Keys:    microsoft
```

#### Troubleshooting

| Issue | Solution |
|-------|----------|
| System won't boot | Disable Secure Boot in BIOS → `sudo sbctl verify` → `sudo sbctl sign-all` → Re-enable |
| "Setup Mode: Enabled" | Run `sudo sbctl enroll-keys --microsoft` |
| Windows dual-boot | Use `--microsoft` flag (required) |

**Notes:**
- Lanzaboot auto-signs new kernels during updates
- Backup keys in `/etc/secureboot/`
- Reinstallation requires repeating all steps

---

### 2.2 Firmware Updates (fwupd)

Keep your hardware firmware up to date for better security, stability, and performance. This is especially important for Framework laptops and other modern hardware.

#### Check for Updates
```bash
# Refresh firmware metadata
fwupdmgr refresh --force

# Check available updates
fwupdmgr get-updates
```

#### Install Updates
```bash
# Install all available firmware updates
fwupdmgr update

# System will reboot if required
```

#### Verify Installation
```bash
# Check firmware versions
fwupdmgr get-devices

# View update history
fwupdmgr get-history
```

#### Automated Updates

To enable automatic firmware updates, edit your configuration:
```nix
# In configModules/hardware.nix or config.nix
services.fwupd.enable = true;
```

Then rebuild:
```bash
rebuild
```

#### Using the Alias

For convenience, use the pre-configured alias:
```bash
# Refresh, check, and install updates in one command
update-firmware
```

This alias is defined in `homeModules/shell.nix` and runs:
- `fwupdmgr refresh --force` - Updates firmware database
- `fwupdmgr get-updates` - Shows available updates
- `fwupdmgr update` - Installs updates

#### Notes

- **Framework Laptop users:** Firmware updates are critical for BIOS, embedded controller, and expansion card functionality
- Updates may require a reboot to apply
- Some updates can only be installed once per boot cycle
- Keep your system plugged in during firmware updates
- Review release notes before major firmware updates

#### Troubleshooting

| Issue | Solution |
|-------|----------|
| "No devices found" | Ensure fwupd service is running: `systemctl status fwupd` |
| Update fails | Check logs: `journalctl -u fwupd -b` |
| Device not listed | Some devices require specific LVFS (Linux Vendor Firmware Service) support |

---

### 2.3 Yubikey Authentication
```bash
mkdir -p ~/.config/Yubico
pamu2fcfg > ~/.config/Yubico/u2f_keys
```

---

### 2.4 Fingerprint (Framework Laptop)
```bash
sudo fprintd-enroll $USER
fprintd-verify
```

---

## 3. Impermanence Configuration

**Only for impermanence installations.** Uncomment these imports:

**In `config.nix`:**
```nix
../../configModules/impermanence.nix
```

**In `home.nix`:**
```nix
../../homeModules/impermanence.nix
```

**Apply changes:**
```bash
sudo nixos-rebuild switch
```

---

## 4. System Verification
```bash
# Check mount points
lsblk -f

# Verify Secure Boot (if enabled)
sudo sbctl status

# Check firmware status
fwupdmgr get-devices

# Test rebuild alias
rebuild
```

---

## 5. Recommended Post-Installation Steps

1. **Update firmware** (see section 2.2)
2. **Configure Git** for your NixOS config repository
3. **Setup Secure Boot** if using compatible hardware
4. **Enable fingerprint** on supported laptops
5. **Test all hardware** (WiFi, Bluetooth, audio, etc.)
6. **Create initial system backup** or snapshot
7. **Document any hardware-specific tweaks** needed

---

## 6. Regular Maintenance
```bash
# Update system packages
update

# Update firmware
update-firmware

# Clean old generations
clean-gen +7  # Keep last 7 generations

# Check system health
rebuild
```
