{ config, lib, pkgs, inputs, ... }:

# Accès SSH unifié au homelab.
# - Les adresses et utilisateurs des serveurs viennent du dépôt PRIVÉ (inputs.secrets → sshHosts) :
#   ce dépôt public ne contient ni topologie réseau ni clé privée.
# - Clé principale : ed25519-sk résidente sur la YubiKey (PIN + appui à chaque connexion).
# - Clé de secours : élément « Clé SSH » du coffre Bitwarden, servie par l'agent SSH de
#   Bitwarden desktop (validation demandée à chaque usage). Aucun fichier privé sur le disque.
#   Seules les clés publiques sont dans keys/ ; la .pub de secours sert à choisir la clé dans l'agent.
let
  secrets = import "${inputs.secrets}/secrets.nix";
  homelabHosts = secrets.sshHosts or { };

  homelabIdentities = [
    "~/.ssh/id_homelab_sk"          # YubiKey (fichier « handle », inutilisable sans la YubiKey)
    "~/.ssh/id_homelab_secours.pub" # secours : clé privée dans Bitwarden, signée via son agent
  ];

  mkHost = name: host:
    {
      HostName = host.hostname;
      User = host.user or "root";
      Port = host.port or 22;
      IdentityFile = homelabIdentities;
      IdentitiesOnly = "yes";
      IdentityAgent = "~/.bitwarden-ssh-agent.sock";
      # Ne rien ajouter à un agent : il ne sait pas demander le PIN de la YubiKey (verify-required).
      AddKeysToAgent = "no";
      ForwardAgent = "no";
      StrictHostKeyChecking = "ask";
    }
    // lib.optionalAttrs (host ? proxyJump) { ProxyJump = host.proxyJump; };

  publicKey = name: lib.optionalAttrs (builtins.pathExists ../keys/${name}) {
    ".ssh/${name}".source = ../keys/${name};
  };
in
{
  services.ssh-agent.enable = true;

  # Bitwarden desktop : agent SSH pour la clé de secours (Réglages → « Activer l'agent SSH »).
  home.packages = [ pkgs.bitwarden-desktop ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config.d/*" ];
    settings = lib.mapAttrs mkHost homelabHosts // {
      "*" = lib.hm.dag.entryAfter (builtins.attrNames homelabHosts) {
        controlMaster = "auto";
        controlPath = "~/.ssh/sockets/S.%r@%h:%p";
        controlPersist = "10m";
        addKeysToAgent = "yes";
        HashKnownHosts = "yes";
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
      };
    };
  };

  home.file = {
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
    ".ssh/config.d/.keep".text = "# SSH config includes";
  }
  // publicKey "id_homelab_sk.pub"
  // publicKey "id_homelab_secours.pub";
}
