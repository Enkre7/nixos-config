# Clés SSH publiques

Ce dépôt est public : on n'y met **que des clés publiques** (`*.pub`), jamais de clé privée.

- `id_homelab_sk.pub` : clé principale, résidente sur la YubiKey (ed25519-sk, appui + PIN).
- `id_homelab_secours.pub` : clé de secours ed25519 générée dans le coffre Bitwarden et servie par l'agent SSH de Bitwarden desktop (aucun fichier privé sur le disque), si la YubiKey est absente.
- `id_homelab_openpgp.pub` : clé d'authentification OpenPGP générée DANS la YubiKey (ed25519, appui exigé), pour le téléphone (Termux + OkcAgent + OpenKeychain, en NFC ou USB-C).

Les adresses des serveurs sont dans le dépôt privé `nixos-secrets` (`sshHosts`), utilisé par `homeModules/ssh.nix`.
