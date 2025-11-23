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
    
    setup-repo = "git clone https://github.com/Enkre7/nixos-config /tmp/nixos";
    
    setup-disk = ''
      lsblk && \
      echo "" && \
      echo "Choose installation type:" && \
      echo "1) Standard (persistent root)" && \
      echo "2) Impermanence (ephemeral root)" && \
      read -p "Choice [1/2]: " CHOICE && \
      read -p "Enter DISKNAME to format: " DISKNAME && \
      DISKPATH="/dev/$DISKNAME" && \
      if [ "$CHOICE" = "1" ]; then
        DISKO_FILE="/tmp/nixos/tools/disko.nix"
      elif [ "$CHOICE" = "2" ]; then
        DISKO_FILE="/tmp/nixos/tools/disko-persist.nix"
      else
        echo "Invalid choice, using standard installation"
        DISKO_FILE="/tmp/nixos/tools/disko.nix"
      fi && \
      sudo nix --experimental-features "nix-command flakes" \
        run github:nix-community/disko -- \
        --mode disko $DISKO_FILE \
        --argstr device $DISKPATH && \
      lsblk $DISKPATH --fs
    '';
    
    setup-dir = ''
      echo "" && \
      echo "Choose installation type:" && \
      echo "1) Standard (persistent root)" && \
      echo "2) Impermanence (ephemeral root)" && \
      read -p "Choice [1/2]: " CHOICE && \
      if [ "$CHOICE" = "1" ]; then
        sudo mkdir -p /mnt/etc && \
        sudo cp -r /tmp/nixos /mnt/etc/nixos && \
        echo "" && \
        echo "⚠️  IMPORTANT: Edit configuration before installing!" && \
        echo "   nano /mnt/etc/nixos/hosts/[hostname]/variables.nix" && \
        echo "   Set: flakePath = \"/etc/nixos\"" && \
        echo "" && \
        echo "   Comment impermanence imports in:" && \
        echo "   - config.nix" && \
        echo "   - home.nix" && \
        echo "   - flake.nix" && \
        echo "" && \
        ls -lR /mnt/etc/nixos
      elif [ "$CHOICE" = "2" ]; then
        sudo mkdir -p /mnt/persist/system /mnt/persist/home && \
        sudo cp -r /tmp/nixos /mnt/persist/system/ && \
        echo "" && \
        echo "⚠️  IMPORTANT: Edit configuration before installing!" && \
        echo "   nano /mnt/persist/system/nixos/hosts/[hostname]/variables.nix" && \
        echo "   Set: flakePath = \"/persist/system/nixos\"" && \
        echo "" && \
        echo "   Uncomment impermanence imports in:" && \
        echo "   - config.nix" && \
        echo "   - home.nix" && \
        echo "   - flake.nix" && \
        echo "" && \
        ls -lR /mnt/persist/system
      else
        echo "Invalid choice, using standard installation" && \
        sudo mkdir -p /mnt/etc && \
        sudo cp -r /tmp/nixos /mnt/etc/nixos && \
        echo "" && \
        echo "⚠️  IMPORTANT: Edit configuration before installing!" && \
        echo "   nano /mnt/etc/nixos/hosts/[hostname]/variables.nix" && \
        echo "   Set: flakePath = \"/etc/nixos\"" && \
        echo "" && \
        echo "   Comment impermanence imports in:" && \
        echo "   - config.nix" && \
        echo "   - home.nix" && \
        echo "   - flake.nix" && \
        echo "" && \
        ls -lR /mnt/etc/nixos
      fi
    '';
    
    setup-nixos = ''
      echo "" && \
      echo "Choose installation type:" && \
      echo "1) Standard (persistent root)" && \
      echo "2) Impermanence (ephemeral root)" && \
      read -p "Choice [1/2]: " CHOICE && \
      read -p "Enter flake's config hostname: " HOSTNAME && \
      read -p "Enter lowercase username: " USERNAME && \
      if [ "$CHOICE" = "1" ]; then
        FLAKE_PATH="/mnt/etc/nixos"
      elif [ "$CHOICE" = "2" ]; then
        FLAKE_PATH="/mnt/persist/system/nixos"
      else
        echo "Invalid choice, using standard installation" && \
        FLAKE_PATH="/mnt/etc/nixos"
      fi && \
      sudo nixos-install --flake $FLAKE_PATH#$HOSTNAME && \
      sudo nixos-enter --root /mnt -c "passwd $USERNAME"
    '';    
  }; 
	   
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.hostPlatform = "x86_64-linux";
}
