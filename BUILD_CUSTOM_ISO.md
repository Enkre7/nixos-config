# Building a Custom NixOS ISO

This guide explains how to build a custom NixOS installation ISO.

## Prerequisites

- A working NixOS system or another Linux distribution with Nix installed
- Git
- Sufficient disk space (approximately 2-3 GB for the ISO)

## Build Steps

### 1. Clone the Repository

```bash
git clone https://github.com/Enkre7/nixos-config
cd nixos-config
```

### 2. Build the ISO

```bash
nix build .#nixosConfigurations.customIso.config.system.build.isoImage --out-link /tmp/iso
```

The build process will take several minutes. Once complete, the ISO will be located at:

```bash
/tmp/iso/iso/nixos-*.iso
```

### 3. Write the ISO to a USB Stick

⚠️ **This ERASES ALL DATA on the USB stick!** Identify it with `lsblk`, then replace `sdX` with the whole disk (e.g. `sda`, no partition number):

```bash
sudo dd if=/tmp/iso/iso/nixos-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Customizing the ISO

To modify the ISO configuration, edit `hosts/customIso/configuration.nix`:

```nix
{ pkgs, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];
  
  # Add packages to the ISO
  environment.systemPackages = with pkgs; [
    wget
    disko
    parted
    git
    # Add your packages here
  ];
  
  # Add or modify aliases
  environment.shellAliases = {
    # Your custom aliases
  };
}
```

After making changes, rebuild the ISO:

```bash
nix build .#nixosConfigurations.customIso.config.system.build.isoImage --out-link /tmp/iso
```

## Troubleshooting

### Build Errors

If the build fails, try:

```bash
# Clean previous builds
nix-collect-garbage -d

# Rebuild
nix build .#nixosConfigurations.customIso.config.system.build.isoImage --out-link /tmp/iso
```

## Next Steps

- To create a bootable USB, see [INSTALL.md](INSTALL.md)
- For installation instructions, see [INSTALL.md](INSTALL.md)
- For post-installation setup, see [POST-INSTALL.md](POST-INSTALL.md)
