{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cliphist
    wofi
    wl-clipboard
    tesseract
    flameshot
    libnotify
  ];

  environment.etc."cliphist-smart.sh" = {
    text = ''
      #!/usr/bin/env bash
      
      ACTION=$(echo -e "📋 Coller l'image\n🔤 Extraire le texte (OCR)\n✏️  Éditer l'image" | ${pkgs.wofi}/bin/wofi --dmenu --prompt "Action")
      SELECTION=$(${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi --dmenu --prompt "Sélectionner")
      
      case "$ACTION" in
          "📋 Coller l'image")
              echo "$SELECTION" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
              ;;
          "🔤 Extraire le texte (OCR)")
              echo "$SELECTION" | ${pkgs.cliphist}/bin/cliphist decode | \
                ${pkgs.tesseract}/bin/tesseract stdin stdout -l fra+eng --oem 3 --psm 6 | ${pkgs.wl-clipboard}/bin/wl-copy
              ${pkgs.libnotify}/bin/notify-send "OCR" "Texte extrait et copié"
              ;;
          "✏️  Éditer l'image")
              TMP_FILE="/tmp/cliphist-edit-$(date +%s).png"
              echo "$SELECTION" | ${pkgs.cliphist}/bin/cliphist decode > "$TMP_FILE"
              ${pkgs.flameshot}/bin/flameshot gui --path "$TMP_FILE"
              rm -f "$TMP_FILE"
              ;;
      esac
    '';
    mode = "0755";
  };
}
