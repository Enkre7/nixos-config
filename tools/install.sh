#!/bin/sh
nix-shell -p unzip

curl https://raw.githubusercontent.com/Enkre7/nixos-config/main/tools/disko.nix -o /tmp/disko.nix

lsblk

read -p "Enter HOST: " HOST
read -p "Enter DISKNAME: " DISKNAME

sudo nix --experimental-features "nix-command flakes" \
run github:nix-community/disko -- \
--mode disko /tmp/disko.nix \
--arg device '"/dev/$DISKNAME"'

lsblk

sudo mkdir -p /mnt/persist/system/etc/nixos

curl https://github.com/Enkre7/nixos-config/archive/main.zip -o /tmp/nixos-config.zip
unzip /tmp/nixos-config.zip -d /mnt/persist/system/etc/nixos

nixos-install --root /mnt --flake /mnt/persist/system/etc/nixos#$HOST