{ config, pkgs, ... }:

{
  # Essential security tools
  environment.systemPackages = with pkgs; [
    libnotify # to send report
    vulnix
    lynis
    chkrootkit
    openscap  # Security compliance framework
    clamav    # Antivirus
    
    # Central notification script
    (writeShellScriptBin "security-notify" ''
      #!/bin/bash
      LEVEL="$1"
      TOOL="$2"
      MESSAGE="$3"
      
      # Get user ID for DBUS
      USER_ID=$(id -u ${config.user})
      
      # Send notification directly without sudo
      export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"
      ${pkgs.libnotify}/bin/notify-send -u "$LEVEL" "$TOOL" "$MESSAGE"
    '')
    
    # Manual scan script
    (writeShellScriptBin "run-security-scan" ''
      #!/bin/bash
      echo "----------------------------------------"
      echo "Starting NixOS security scan..."
      echo "----------------------------------------"
      echo "This scan will check for:"
      echo " - Package vulnerabilities (via vulnix)"
      echo " - System hardening (via lynis)"
      echo " - Rootkit detection (via chkrootkit)"
      echo " - Nix store integrity"
      echo " - Open ports (via nmap)"
      echo " - SUID/SGID binaries"
      echo " - World-writable files"
      echo ""
      echo "The report will be saved to: ~/security-report.txt"
      echo "You can view it with: view-security-report"
      echo ""
      echo "Starting systemd service: security-scan.service"
      sudo systemctl start security-scan.service
      
      # Check if the service started successfully
      if [ $? -eq 0 ]; then
        echo "Scan initiated successfully."
        echo "Monitor progress with: journalctl -fu security-scan.service"
        echo "You will receive a notification when the scan completes."
      else
        echo "Error: Failed to start security scan service."
        echo "Check the logs with: journalctl -u security-scan.service"
      fi
      echo "----------------------------------------"
    '')
    
    # View report script
    (writeShellScriptBin "view-security-report" ''
      #!/bin/bash
      REPORT_PATH="$HOME/security-report.txt"
      SCAN_DIR="/var/lib/security-scans"
      
      echo "----------------------------------------"
      echo "NixOS Security Report Viewer"
      echo "----------------------------------------"
      
      if [ -f "$REPORT_PATH" ]; then
        echo "Found security report at: $REPORT_PATH"
        echo "Report date: $(stat -c '%y' "$REPORT_PATH")"
        echo "Report size: $(stat -c '%s' "$REPORT_PATH") bytes"
        echo ""
        echo "Press q to exit the report viewer"
        echo "----------------------------------------"
        sleep 1
        ${pkgs.less}/bin/less "$REPORT_PATH"
      else
        echo "No security report found at: $REPORT_PATH"
        echo ""
        
        # Check if there are any reports in the system directory
        if [ -d "$SCAN_DIR" ] && [ "$(ls -A "$SCAN_DIR" 2>/dev/null)" ]; then
          echo "System reports exist but haven't been copied to your home directory."
          echo "Available system reports:"
          sudo ls -lh "$SCAN_DIR" | grep report
          echo ""
          echo "You can copy the latest report with:"
          echo "sudo cp $SCAN_DIR/latest-report.txt $REPORT_PATH"
          echo "sudo chown $(whoami):users $REPORT_PATH"
        else
          echo "No system reports found. Run 'run-security-scan' to generate one."
        fi
        echo "----------------------------------------"
      fi
    '')
  ];

  # Enhanced weekly security scan
  systemd.services.security-scan = {
    description = "Weekly security scan";
    path = with pkgs; [ 
      vulnix lynis chkrootkit clamav 
      nmap coreutils gnugrep gawk findutils 
    ];
    script = ''
      # Use bash for more robust error handling
      #!/usr/bin/env bash
      set -e  # Exit on error
      
      # Directory for results
      SCAN_DIR="/var/lib/security-scans"
      mkdir -p $SCAN_DIR
      TIMESTAMP=$(date +%F-%H%M)
      REPORT_FILE="$SCAN_DIR/report-$TIMESTAMP.txt"
      
      # Log function
      log() {
        echo "$1" >> "$REPORT_FILE"
        echo "$1"
      }
      
      # Helper function to ensure we have a valid integer
      ensure_number() {
        local num="$1"
        # Remove any non-numeric characters and ensure at least "0"
        echo "${num//[^0-9]/}" | sed 's/^$/0/'
      }
      
      log "Security Scan Report - $(date)"
      log "==========================="
      log ""
      
      # 1. Package vulnerability scan
      log "## Package Vulnerabilities (Vulnix)"
      if command -v vulnix >/dev/null 2>&1; then
        VULNIX_FILE="$SCAN_DIR/vulnix-$TIMESTAMP.txt"
        # Run vulnix with proper error handling
        if vulnix --system > "$VULNIX_FILE" 2>/dev/null; then
          # Count vulnerabilities properly
          VULN_COUNT=$(ensure_number "$(grep -c "CVE-" "$VULNIX_FILE" 2>/dev/null || echo 0)")
          CRITICAL_VULN=$(ensure_number "$(grep -c "CVE.*critical" "$VULNIX_FILE" 2>/dev/null || echo 0)")
          log "Total vulnerabilities: $VULN_COUNT (Critical: $CRITICAL_VULN)"
          
          # List a few of the vulnerabilities if there are any
          if [ "$VULN_COUNT" -gt 0 ]; then
            log "Sample vulnerabilities:"
            grep "CVE-" "$VULNIX_FILE" 2>/dev/null | head -3 | while read -r line; do
              log "- $line"
            done
          fi
        else
          log "Vulnix scan failed to execute properly."
          VULN_COUNT=0
          CRITICAL_VULN=0
        fi
      else
        log "Vulnix not available on this system."
        VULN_COUNT=0
        CRITICAL_VULN=0
      fi
      
      # 2. System security audit
      log ""
      log "## System Hardening (Lynis)"
      if command -v lynis >/dev/null 2>&1; then
        LYNIS_FILE="$SCAN_DIR/lynis-$TIMESTAMP.txt"
        if lynis audit system --no-colors --quiet > "$LYNIS_FILE" 2>/dev/null; then
          # Get hardening score with proper error handling
          SECURITY_SCORE=$(ensure_number "$(grep "Hardening index" "$LYNIS_FILE" 2>/dev/null | grep -o "[0-9]*" || echo 0)")
          SUGGESTIONS=$(ensure_number "$(grep -c "Suggestion" "$LYNIS_FILE" 2>/dev/null || echo 0)")
          WARNINGS=$(ensure_number "$(grep -c "Warning" "$LYNIS_FILE" 2>/dev/null || echo 0)")
          log "Security hardening score: $SECURITY_SCORE/100"
          log "Warnings: $WARNINGS"
          log "Suggestions: $SUGGESTIONS"
          
          # Show some sample suggestions
          if [ "$SUGGESTIONS" -gt 0 ]; then
            log "Sample suggestions:"
            grep "Suggestion" "$LYNIS_FILE" 2>/dev/null | head -3 | while read -r line; do
              log "- $line"
            done
          fi
        else
          log "Lynis scan failed to execute properly."
          SECURITY_SCORE=0
          SUGGESTIONS=0
          WARNINGS=0
        fi
      else
        log "Lynis not available on this system."
        SECURITY_SCORE=0
        SUGGESTIONS=0
        WARNINGS=0
      fi
      
      # 3. Rootkit detection
      log ""
      log "## Rootkit Detection"
      if command -v chkrootkit >/dev/null 2>&1; then
        CHKROOTKIT_FILE="$SCAN_DIR/chkrootkit-$TIMESTAMP.txt"
        if chkrootkit -q > "$CHKROOTKIT_FILE" 2>/dev/null; then
          CHKROOTKIT_FOUND=$(ensure_number "$(grep -c -E "INFECTED|SUSPECT" "$CHKROOTKIT_FILE" 2>/dev/null || echo 0)")
          log "Chkrootkit indicators: $CHKROOTKIT_FOUND"
          
          # Show infected files if any
          if [ "$CHKROOTKIT_FOUND" -gt 0 ]; then
            log "Possible rootkit infections:"
            grep -E "INFECTED|SUSPECT" "$CHKROOTKIT_FILE" 2>/dev/null | while read -r line; do
              log "- $line"
            done
          fi
        else
          log "Chkrootkit scan completed with warnings."
          CHKROOTKIT_FOUND=0
        fi
      else
        log "Chkrootkit not available on this system."
        CHKROOTKIT_FOUND=0
      fi
      
      # 4. Native Nix Store Integrity Check
      log ""
      log "## Nix Store Integrity Check"
      NIX_STORE_FILE="$SCAN_DIR/nixstore-$TIMESTAMP.txt"
      if nix-store --verify --check-contents 2>&1 | head -n 20 > "$NIX_STORE_FILE"; then
        NIX_ERRORS=$(ensure_number "$(grep -c -i "error\|corrupt\|invalid" "$NIX_STORE_FILE" 2>/dev/null || echo 0)")
        log "Nix store integrity issues: $NIX_ERRORS"
        if [ "$NIX_ERRORS" -gt 0 ]; then
          log "IMPORTANT: Issues detected in Nix store integrity check!"
          grep -i "error\|corrupt\|invalid" "$NIX_STORE_FILE" 2>/dev/null | head -5 | while read -r line; do
            log "- $line"
          done
        else
          log "Nix store appears to be intact"
        fi
      else
        log "Nix store verification failed to complete."
        NIX_ERRORS=0
      fi
      
      # 5. Port scan
      log ""
      log "## Open Ports"
      if command -v nmap >/dev/null 2>&1; then
        NMAP_FILE="$SCAN_DIR/portscan-$TIMESTAMP.txt"
        if nmap -F localhost > "$NMAP_FILE" 2>/dev/null; then
          OPEN_PORTS=$(ensure_number "$(grep "open" "$NMAP_FILE" 2>/dev/null | wc -l)")
          log "Open ports: $OPEN_PORTS"
          grep "open" "$NMAP_FILE" 2>/dev/null | while read -r line; do
            log "- $line"
          done
        else
          log "Port scan failed to complete."
          OPEN_PORTS=0
        fi
      else
        log "Nmap not available on this system."
        OPEN_PORTS=0
      fi
      
      # 6. Check setuid/setgid binaries
      log ""
      log "## SUID/SGID Binaries"
      SETUID_FILE="$SCAN_DIR/setuid-$TIMESTAMP.txt"
      if find / -path /proc -prune -o -path /nix/store -prune -o \( -perm -4000 -o -perm -2000 \) -type f -ls 2>/dev/null > "$SETUID_FILE"; then
        SETUID_COUNT=$(ensure_number "$(wc -l < "$SETUID_FILE" 2>/dev/null || echo 0)")
        log "SetUID/SetGID binaries found: $SETUID_COUNT"
        
        # List a few for example
        if [ "$SETUID_COUNT" -gt 0 ]; then
          log "Sample SUID/SGID binaries:"
          head -3 "$SETUID_FILE" 2>/dev/null | while read -r line; do
            log "- $line"
          done
        fi
      else
        log "SUID/SGID scan encountered some errors (permissions)."
        # Still try to count what we got
        if [ -f "$SETUID_FILE" ]; then
          SETUID_COUNT=$(ensure_number "$(wc -l < "$SETUID_FILE" 2>/dev/null || echo 0)")
          log "Partial results - SetUID/SetGID binaries found: $SETUID_COUNT"
        else
          SETUID_COUNT=0
        fi
      fi
      
      # 7. World-writable files
      log ""
      log "## World-Writable Files"
      WW_FILE="$SCAN_DIR/world-writable-$TIMESTAMP.txt"
      if find / -path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -path /nix/store -prune -o -perm -2 ! -type l -ls 2>/dev/null > "$WW_FILE"; then
        WW_COUNT=$(ensure_number "$(wc -l < "$WW_FILE" 2>/dev/null || echo 0)")
        log "World-writable files/dirs found: $WW_COUNT"
        
        # List a few for example
        if [ "$WW_COUNT" -gt 0 ]; then
          log "Sample world-writable files:"
          head -3 "$WW_FILE" 2>/dev/null | while read -r line; do
            log "- $line"
          done
        fi
      else
        log "World-writable files scan encountered some errors (permissions)."
        # Still try to count what we got
        if [ -f "$WW_FILE" ]; then
          WW_COUNT=$(ensure_number "$(wc -l < "$WW_FILE" 2>/dev/null || echo 0)")
          log "Partial results - World-writable files/dirs found: $WW_COUNT"
        else
          WW_COUNT=0
        fi
      fi
      
      # Create a risk score
      log ""
      log "## Summary"
      RISK_SCORE=0
      
      # Calculate risk score with safer integer conversions
      if [ "$CRITICAL_VULN" -gt 0 ] 2>/dev/null; then 
        RISK_SCORE=$((RISK_SCORE+40))
        log "- Critical vulnerabilities found: +40 points"
      fi
      
      if [ "$VULN_COUNT" -gt 5 ] 2>/dev/null; then 
        RISK_SCORE=$((RISK_SCORE+10))
        log "- Multiple vulnerabilities found: +10 points"
      fi
      
      if [ "$SECURITY_SCORE" -lt 70 ] 2>/dev/null; then 
        RISK_SCORE=$((RISK_SCORE+20))
        log "- Low security hardening score: +20 points"
      fi
      
      if [ "$WARNINGS" -gt 5 ] 2>/dev/null; then 
        RISK_SCORE=$((RISK_SCORE+10))
        log "- Multiple security warnings: +10 points"
      fi
      
      if [ "$CHKROOTKIT_FOUND" -gt 0 ] 2>/dev/null; then 
        RISK_SCORE=$((RISK_SCORE+30))
        log "- Potential rootkit indicators: +30 points"
      fi
      
      if [ "$NIX_ERRORS" -gt 0 ] 2>/dev/null; then 
        RISK_SCORE=$((RISK_SCORE+50))
        log "- Nix store integrity issues: +50 points"
      fi
      
      # Risk assessment
      if [ "$RISK_SCORE" -ge 50 ] 2>/dev/null; then
        RISK_LEVEL="HIGH"
      elif [ "$RISK_SCORE" -ge 20 ] 2>/dev/null; then
        RISK_LEVEL="MEDIUM"
      else
        RISK_LEVEL="LOW"
      fi
      
      log "Overall risk assessment: $RISK_LEVEL ($RISK_SCORE points)"
      
      # Copy report for user - no need for sudo in systemd service run as root
      cp "$REPORT_FILE" "/home/${config.user}/security-report.txt" || echo "Failed to copy report to user home"
      chown ${config.user}:users "/home/${config.user}/security-report.txt" 2>/dev/null || echo "Failed to set ownership on report"
      
      # Create symlink to latest report
      ln -sf "$REPORT_FILE" "$SCAN_DIR/latest-report.txt" || echo "Failed to create symlink to latest report"
      
      # Send notification - directly using libnotify
      USER_ID=$(id -u ${config.user})
      DBUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"
      
      if [ "$RISK_LEVEL" = "HIGH" ]; then
        # Use printenv to debug environment
        DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDRESS" \
          su - ${config.user} -c "${pkgs.libnotify}/bin/notify-send -u critical 'Security Scan' 'HIGH security risks detected! Check ~/security-report.txt'" || \
          echo "Failed to send notification"
      elif [ "$RISK_LEVEL" = "MEDIUM" ]; then
        DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDRESS" \
          su - ${config.user} -c "${pkgs.libnotify}/bin/notify-send -u normal 'Security Scan' 'MEDIUM security risks detected. Check ~/security-report.txt'" || \
          echo "Failed to send notification"
      else
        DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDRESS" \
          su - ${config.user} -c "${pkgs.libnotify}/bin/notify-send -u low 'Security Scan' 'Security scan completed. Risk level: LOW'" || \
          echo "Failed to send notification"
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # Schedule scan for weeknights at 3 AM
  systemd.timers.security-scan = {
    description = "Weeknight security scan timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
    };
  };

  # ClamAV configuration
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    scanner = {
      enable = true;
      interval = "daily";
      scanDirectories = [ 
        "/home/${config.user}" 
        "/tmp"
        "/var/tmp"
      ];
    };
  };

  # Create necessary directories
  systemd.tmpfiles.rules = [
    "d /var/lib/security-scans 0750 root root -"
  ];
}
