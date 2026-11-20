# Clés SSH publiques

Ce dépôt est public : on n'y met **que des clés publiques** (`*.pub`), jamais de clé privée.

## Homelab
- `id_homelab_sk.pub` : clé principale, résidente sur la YubiKey (ed25519-sk, appui + PIN).
- `id_homelab_secours.pub` : clé de secours ed25519 générée dans le coffre Bitwarden et servie par l'agent SSH de Bitwarden desktop (aucun fichier privé sur le disque), si la YubiKey est absente.
- `id_homelab_openpgp.pub` : clé d'authentification OpenPGP générée DANS la YubiKey (ed25519, appui exigé), pour le téléphone (Termux + OkcAgent + OpenKeychain, en NFC ou USB-C).

## GitHub
- `id_github_bitwarden.pub` : clé du quotidien, élément « GitHub » du coffre Bitwarden (agent SSH de Bitwarden desktop).
- `id_github_sk.pub` : secours, clé résidente sur la YubiKey (application `ssh:github`, appui + PIN).

## Nouvelle installation
Les dépôts se clonent en HTTPS (`gh auth login`), aucune clé SSH n'est nécessaire pour installer.
Après le premier switch :
1. Bitwarden desktop : se connecter, activer l'agent SSH (les clés « Homelab secours » et « GitHub » suivent le coffre).
2. Recréer les fichiers « handle » des clés résidentes depuis la YubiKey (PIN demandé) :
   ```
   cd ~/.ssh && ssh-keygen -K
   mv id_ed25519_sk_rk_homelab id_homelab_sk
   mv id_ed25519_sk_rk_github id_github_sk
   rm -f id_ed25519_sk_rk_*.pub   # les .pub sont fournies par ce dépôt
   ```
Les clés d'hôte des serveurs et de GitHub sont déclarées (`~/.ssh/known_hosts_nix`) : aucune question « yes/no » à la première connexion.

Les adresses et clés d'hôte des serveurs sont dans le dépôt privé `nixos-secrets` (`sshHosts`), utilisé par `homeModules/ssh.nix`.
