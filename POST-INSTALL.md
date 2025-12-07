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

### 2.2 Yubikey Authentication

```bash
mkdir -p ~/.config/Yubico
pamu2fcfg > ~/.config/Yubico/u2f_keys
```

---

### 2.3 Fingerprint (Framework Laptop)

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

# Test rebuild alias
rebuild
```
