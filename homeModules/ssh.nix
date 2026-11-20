{ config, lib, pkgs, inputs, ... }:

# Accès SSH unifié au homelab.
# - Les adresses et utilisateurs des serveurs viennent du dépôt PRIVÉ (inputs.secrets → sshHosts) :
#   ce dépôt public ne contient ni topologie réseau ni clé privée.
# - Clé principale : ed25519-sk résidente sur la YubiKey (PIN + appui à chaque connexion).
# - Clé de secours : élément « Clé SSH » du coffre Bitwarden, servie par l'agent SSH de
#   Bitwarden desktop (validation demandée à chaque usage). Aucun fichier privé sur le disque.
#   Seules les clés publiques sont dans keys/ ; la .pub de secours sert à choisir la clé dans l'agent.
# - GitHub : clé « GitHub » du coffre Bitwarden (quotidien), puis clé résidente YubiKey (secours).
# - known_hosts déclaratif : clés d'hôte des serveurs dans sshHosts.*.hostKey (dépôt privé) + clés
#   publiées par GitHub → ~/.ssh/known_hosts_nix, vérification stricte (aucune question « yes/no »).
# - Les fichiers « handle » des clés résidentes YubiKey ne sont pas versionnés : ssh-keygen -K les
#   recrée depuis la YubiKey (voir keys/README.md).
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
      UserKnownHostsFile = "~/.ssh/known_hosts_nix";
      StrictHostKeyChecking = if host ? hostKey then "yes" else "ask";
    }
    // lib.optionalAttrs (host ? proxyJump) { ProxyJump = host.proxyJump; }
    // lib.optionalAttrs (host ? remoteCommand) {
      RemoteCommand = host.remoteCommand;
      RequestTTY = "yes";
    };

  # Clés d'hôte publiées par GitHub (https://api.github.com/meta, champ ssh_keys).
  githubHostKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk="
  ];

  # Une ligne par serveur : tous ses alias + son adresse réelle. pbs-carbon partage la clé de carbon.
  knownHostLines = lib.mapAttrsToList
    (name: host: "${lib.concatStringsSep "," (lib.unique (lib.splitString " " name ++ [ host.hostname ]))} ${host.hostKey}")
    (lib.filterAttrs (_: host: host ? hostKey) homelabHosts);

  knownHostsNix = lib.concatStringsSep "\n" (
    knownHostLines ++ map (key: "github.com ${key}") githubHostKeys
  ) + "\n";

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
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = [
          "~/.ssh/id_github_bitwarden.pub" # quotidien : clé privée dans Bitwarden, signée via son agent
          "~/.ssh/id_github_sk"            # secours : clé résidente YubiKey (PIN + appui)
        ];
        IdentitiesOnly = "yes";
        IdentityAgent = "~/.bitwarden-ssh-agent.sock";
        AddKeysToAgent = "no";
        ForwardAgent = "no";
        UserKnownHostsFile = "~/.ssh/known_hosts_nix";
        StrictHostKeyChecking = "yes";
      };
      "*" = lib.hm.dag.entryAfter ((builtins.attrNames homelabHosts) ++ [ "github.com" ]) {
        controlMaster = "auto";
        controlPath = "~/.ssh/sockets/S.%r@%h:%p";
        controlPersist = "10m";
        addKeysToAgent = "yes";
        HashKnownHosts = "yes";
        # Hôtes hors homelab : appris dans ~/.ssh/known_hosts ; known_hosts_nix reste consulté.
        UserKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/known_hosts_nix";
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
      };
    };
  };

  home.file = {
    # gpg (carte OpenPGP de la YubiKey, clé SSH du téléphone) doit passer par pcscd, activé dans
    # configModules/yubikey.nix ; sinon scdaemon ne voit pas la carte (« Aucun périphérique »).
    ".gnupg/scdaemon.conf" = {
      text = ''
        disable-ccid
        pcsc-shared
      '';
      force = true;
    };
    ".ssh/known_hosts_nix".text = knownHostsNix;
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
    ".ssh/config.d/.keep".text = "# SSH config includes";
  }
  // publicKey "id_homelab_sk.pub"
  // publicKey "id_homelab_secours.pub"
  // publicKey "id_github_bitwarden.pub"
  // publicKey "id_github_sk.pub";
}
