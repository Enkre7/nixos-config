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
nix build .#nixosConfigurations.customIso.config.system.build.isoImage
```

The build process will take several minutes. Once complete, the ISO will be located at:

```bash
./result/iso/nixos-*.iso
```

### 3. Copy the ISO (Optional)

Copy the ISO to a convenient location:

```bash
cp ./result/iso/nixos-*.iso ~/nixos-custom.iso
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
nix build .#nixosConfigurations.customIso.config.system.build.isoImage
```

## Troubleshooting

### Build Errors

If the build fails, try:

```bash
# Clean previous builds
nix-collect-garbage -d

# Rebuild
nix build .#nixosConfigurations.customIso.config.system.build.isoImage
```

## Next Steps

- To create a bootable USB, see [INSTALL.md](INSTALL.md)
- For installation instructions, see [INSTALL.md](INSTALL.md)
- For post-installation setup, see [POST-INSTALL.md](POST-INSTALL.md)
