# Clés SSH publiques

Ce dépôt est public : on n'y met **que des clés publiques** (`*.pub`), jamais de clé privée.

- `id_homelab_sk.pub` : clé principale, résidente sur la YubiKey (ed25519-sk, appui + PIN).
- `id_homelab_secours.pub` : clé de secours logicielle (ed25519, phrase de passe), si la YubiKey est absente.

Les adresses des serveurs sont dans le dépôt privé `nixos-secrets` (`sshHosts`), utilisé par `homeModules/ssh.nix`.
