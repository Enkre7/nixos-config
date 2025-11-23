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

  home.file.".local/bin/cliphist-smart.sh" = {
    text = ''
      #!/usr/bin/env bash
      
      ACTION=$(echo -e "📋 Coller l'image\n🔤 Extraire le texte (OCR)\n✏️  Éditer l'image" | wofi --dmenu --prompt "Action")
      SELECTION=$(cliphist list | wofi --dmenu --prompt "Sélectionner")
      
      case "$ACTION" in
          "📋 Coller l'image")
              echo "$SELECTION" | cliphist decode | wl-copy
              ;;
          "🔤 Extraire le texte (OCR)")
              echo "$SELECTION" | cliphist decode | \
                tesseract stdin stdout -l fra+eng --oem 3 --psm 6 | wl-copy
              notify-send "OCR" "Texte extrait et copié"
              ;;
          "✏️  Éditer l'image")
              TMP_FILE="/tmp/cliphist-edit-$(date +%s).png"
              echo "$SELECTION" | cliphist decode > "$TMP_FILE"
              flameshot gui --path "$TMP_FILE"
              rm -f "$TMP_FILE"
              ;;
      esac
    '';
    executable = true;
  };
}
