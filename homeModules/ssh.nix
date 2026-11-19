{ config, lib, pkgs, inputs, ... }:

# Accès SSH unifié au homelab.
# - Les adresses et utilisateurs des serveurs viennent du dépôt PRIVÉ (inputs.secrets → sshHosts) :
#   ce dépôt public ne contient ni topologie réseau ni clé privée.
# - Clé principale : ed25519-sk résidente sur la YubiKey (appui + PIN à chaque connexion).
#   Clé de secours : ed25519 logicielle avec phrase de passe, jamais versionnée.
#   Seules les clés publiques sont dans keys/.
let
  secrets = import "${inputs.secrets}/secrets.nix";
  homelabHosts = secrets.sshHosts or { };

  homelabIdentities = [
    "~/.ssh/id_homelab_sk"      # YubiKey
    "~/.ssh/id_homelab_secours" # secours, protégée par phrase de passe
  ];

  mkHost = name: host:
    {
      HostName = host.hostname;
      User = host.user or "root";
      Port = host.port or 22;
      IdentityFile = homelabIdentities;
      IdentitiesOnly = "yes";
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
