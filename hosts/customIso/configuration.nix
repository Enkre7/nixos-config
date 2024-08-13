{ pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  environment.systemPackages = with pkgs; [
    wget
    disko
    parted
    git
  ];

  environment.shellAliases = {
    setup-wifi = ''
      ifconfig && \
      read -p "Enter wifi interface: " INTERFACE && \
      read -p "Enter wifi SSID: " WIFI_SSID && \
      read -p "Enter wifi password: " WIFI_PASSWORD && \
      wpa_passphrase '$WIFI_SSID' '$WIFI_PASSWORD' | sudo wpa_supplicant -B -i $INTERFACE -c /dev/stdin
    '';
    
    setup-repo = ''
      nix-shell -p git --command "git clone https://github.com/Enkre7/nixos-config /tmp/nixos"
    '';
    
    setup-disk = ''
      lsblk && \
      read -p "Enter DISKNAME to format: " DISKNAME && \
      sudo nix --experimental-features "nix-command flakes" \
        run github:nix-community/disko -- \
        --mode disko /tmp/nixos/tools/disko.nix \
        --arg device '"/dev/$DISKNAME"' && \
      sleep 0.2s && \
      lsblk /dev/$DISKNAME --fs
    ''; # need to fix diskname variable not being passed to disko command
    
    setup-dir = ''
      sudo mkdir -p /mnt/persist/system && \
      sudo mkdir -p /mnt/persist/home && \
      sudo cp -r /tmp/nixos /mnt/persist/system/
    '';
    
    setup-nixos = ''
      read -p "Enter flake's config hostname: " HOSTNAME && \
      read -p "Enter username: " USERNAME && \
      nix-shell -p git --command "sudo nixos-install --flake /mnt/persist/system/nixos#$HOSTNAME" && \
      passwd $USERNAME
    '';
  }; 
    
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
