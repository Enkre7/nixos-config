{ lib, ... }:

{
  # Keep every secret in the "login" keyring, the one PAM (greetd/login) unlocks
  # with the session password. Without this, the first app asking for the default
  # collection before "login" exists (e.g. a fingerprint login right after install)
  # gets a separate "Default keyring" with its own password, prompted on every
  # git push or Nextcloud start.
  home.activation.keyringDefaultLogin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    keyrings="$HOME/.local/share/keyrings"
    if [ "$(cat "$keyrings/default" 2>/dev/null)" != "login" ]; then
      run mkdir -p "$keyrings"
      run sh -c 'printf login > "$1"' _ "$keyrings/default"
    fi
    for k in "$keyrings"/*.keyring; do
      [ -e "$k" ] || continue
      case "$(basename "$k")" in
        login.keyring|user.keystore) ;;
        *) warnEcho "Extra keyring $k: move its items into \"login\" (seahorse) and delete it" ;;
      esac
    done
  '';
}
