{ config, pkgs, ... }:

{
  # Essential security tools
  environment.systemPackages = with pkgs; [
    libnotify # to send repport
    vulnix
    lynis
    chkrootkit
    rkhunter  # Alternative rootkit detector
    tiger     # System security checker
    aide      # File integrity checker
    openscap  # Security compliance framework
    sn0int    # OSINT security reconnaissance tool
    clamav    # Antivirus
    tripwire  # File change detection system
  ];

  # Central notification script
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "security-notify" ''
      #!/bin/sh
      LEVEL="$1"
      TOOL="$2"
      MESSAGE="$3"
      
      # Get user ID for DBUS
      USER_ID=$(id -u ${config.user})
      
      # Send notification
      export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"
      sudo -u ${config.user} DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
        ${pkgs.libnotify}/bin/notify-send -u "$LEVEL" "$TOOL" "$MESSAGE"
    '')
  ];

  # Enhanced weekly security scan
  systemd.services.security-scan = {
    description = "Weekly security scan";
    path = with pkgs; [ 
      vulnix lynis chkrootkit rkhunter aide tiger clamav 
      tripwire nmap coreutils gnugrep gawk findutils 
    ];
    script = ''
      # Directory for results
      SCAN_DIR="/var/lib/security-scans"
      mkdir -p $SCAN_DIR
      TIMESTAMP=$(date +%F-%H%M)
      REPORT_FILE="$SCAN_DIR/report-$TIMESTAMP.txt"
      
      echo "Security Scan Report - $(date)" > $REPORT_FILE
      echo "===========================" >> $REPORT_FILE
      echo "" >> $REPORT_FILE
      
      # 1. Package vulnerability scan
      echo "## Package Vulnerabilities (Vulnix)" >> $REPORT_FILE
      vulnix --system > $SCAN_DIR/vulnix-$TIMESTAMP.txt
      VULN_COUNT=$(grep -c "CVE-" $SCAN_DIR/vulnix-$TIMESTAMP.txt || echo 0)
      CRITICAL_VULN=$(grep -c "CVE.*critical" $SCAN_DIR/vulnix-$TIMESTAMP.txt || echo 0)
      echo "Total vulnerabilities: $VULN_COUNT (Critical: $CRITICAL_VULN)" >> $REPORT_FILE
      
      # 2. System security audit
      echo "" >> $REPORT_FILE
      echo "## System Hardening (Lynis)" >> $REPORT_FILE
      lynis audit system --no-colors --quiet > $SCAN_DIR/lynis-$TIMESTAMP.txt
      SECURITY_SCORE=$(grep "Hardening index" $SCAN_DIR/lynis-$TIMESTAMP.txt | grep -o "[0-9]*" || echo 0)
      SUGGESTIONS=$(grep -c "Suggestion" $SCAN_DIR/lynis-$TIMESTAMP.txt || echo 0)
      WARNINGS=$(grep -c "Warning" $SCAN_DIR/lynis-$TIMESTAMP.txt || echo 0)
      echo "Security hardening score: $SECURITY_SCORE/100" >> $REPORT_FILE
      echo "Warnings: $WARNINGS" >> $REPORT_FILE
      echo "Suggestions: $SUGGESTIONS" >> $REPORT_FILE
      
      # 3. Rootkit detection
      echo "" >> $REPORT_FILE
      echo "## Rootkit Detection" >> $REPORT_FILE
      
      # Chkrootkit
      chkrootkit -q > $SCAN_DIR/chkrootkit-$TIMESTAMP.txt
      CHKROOTKIT_FOUND=$(grep -c -E "INFECTED|SUSPECT" $SCAN_DIR/chkrootkit-$TIMESTAMP.txt || echo 0)
      echo "Chkrootkit indicators: $CHKROOTKIT_FOUND" >> $REPORT_FILE
      
      # RKHunter
      rkhunter --checkall --skip-keypress --quiet > $SCAN_DIR/rkhunter-$TIMESTAMP.txt
      RKHUNTER_FOUND=$(grep -c "Warning" $SCAN_DIR/rkhunter-$TIMESTAMP.txt || echo 0)
      echo "RKHunter warnings: $RKHUNTER_FOUND" >> $REPORT_FILE
      
      # 4. File integrity check
      echo "" >> $REPORT_FILE
      echo "## File Integrity (AIDE)" >> $REPORT_FILE
      if [ ! -f /var/lib/aide/aide.db.gz ]; then
        echo "Initializing AIDE database..." >> $REPORT_FILE
        aide --init > $SCAN_DIR/aide-init-$TIMESTAMP.txt
        cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
        echo "AIDE database initialized. First check will be available next scan." >> $REPORT_FILE
      else
        aide --check > $SCAN_DIR/aide-$TIMESTAMP.txt 2>&1
        AIDE_CHANGES=$(grep -c -E "changed|added|removed" $SCAN_DIR/aide-$TIMESTAMP.txt || echo 0)
        echo "Changed files detected: $AIDE_CHANGES" >> $REPORT_FILE
      fi
      
      # 5. Port scan
      echo "" >> $REPORT_FILE
      echo "## Open Ports" >> $REPORT_FILE
      nmap -F localhost > $SCAN_DIR/portscan-$TIMESTAMP.txt
      OPEN_PORTS=$(grep "open" $SCAN_DIR/portscan-$TIMESTAMP.txt | wc -l)
      echo "Open ports: $OPEN_PORTS" >> $REPORT_FILE
      grep "open" $SCAN_DIR/portscan-$TIMESTAMP.txt | sed 's/^/- /' >> $REPORT_FILE
      
      # 6. Check setuid/setgid binaries
      echo "" >> $REPORT_FILE
      echo "## SUID/SGID Binaries" >> $REPORT_FILE
      find / -path /proc -prune -o \( -perm -4000 -o -perm -2000 \) -type f -ls 2>/dev/null > $SCAN_DIR/setuid-$TIMESTAMP.txt
      SETUID_COUNT=$(wc -l < $SCAN_DIR/setuid-$TIMESTAMP.txt)
      echo "SetUID/SetGID binaries found: $SETUID_COUNT" >> $REPORT_FILE
      
      # 7. World-writable files
      echo "" >> $REPORT_FILE
      echo "## World-Writable Files" >> $REPORT_FILE
      find / -path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -perm -2 ! -type l -ls 2>/dev/null > $SCAN_DIR/world-writable-$TIMESTAMP.txt
      WW_COUNT=$(wc -l < $SCAN_DIR/world-writable-$TIMESTAMP.txt)
      echo "World-writable files/dirs found: $WW_COUNT" >> $REPORT_FILE
      
      # Create a risk score
      echo "" >> $REPORT_FILE
      echo "## Summary" >> $REPORT_FILE
      RISK_SCORE=0
      
      # Calculate risk score
      [ "$CRITICAL_VULN" -gt 0 ] && RISK_SCORE=$((RISK_SCORE+40))
      [ "$VULN_COUNT" -gt 5 ] && RISK_SCORE=$((RISK_SCORE+10))
      [ "$SECURITY_SCORE" -lt 70 ] && RISK_SCORE=$((RISK_SCORE+20))
      [ "$WARNINGS" -gt 5 ] && RISK_SCORE=$((RISK_SCORE+10))
      [ "$CHKROOTKIT_FOUND" -gt 0 ] && RISK_SCORE=$((RISK_SCORE+30))
      [ "$RKHUNTER_FOUND" -gt 0 ] && RISK_SCORE=$((RISK_SCORE+20))
      [ "$AIDE_CHANGES" -gt 10 ] && RISK_SCORE=$((RISK_SCORE+15))
      
      # Risk assessment
      if [ "$RISK_SCORE" -ge 50 ]; then
        RISK_LEVEL="HIGH"
      elif [ "$RISK_SCORE" -ge 20 ]; then
        RISK_LEVEL="MEDIUM"
      else
        RISK_LEVEL="LOW"
      fi
      
      echo "Overall risk assessment: $RISK_LEVEL ($RISK_SCORE points)" >> $REPORT_FILE
      
      # Copy report for user
      cp $REPORT_FILE /home/${config.user}/security-report.txt
      chown ${config.user}:users /home/${config.user}/security-report.txt
      
      # Create symlink to latest report
      ln -sf $REPORT_FILE $SCAN_DIR/latest-report.txt
      
      # Send notification
      if [ "$RISK_LEVEL" = "HIGH" ]; then
        /run/current-system/sw/bin/security-notify critical "Security Scan" "HIGH security risks detected! Check ~/security-report.txt"
      elif [ "$RISK_LEVEL" = "MEDIUM" ]; then
        /run/current-system/sw/bin/security-notify normal "Security Scan" "MEDIUM security risks detected. Check ~/security-report.txt"
      else
        /run/current-system/sw/bin/security-notify low "Security Scan" "Security scan completed. Risk level: LOW"
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

  # Utility scripts
  environment.systemPackages = with pkgs; [
    # Manual scan script
    (writeShellScriptBin "run-security-scan" ''
      #!/bin/sh
      echo "Running security scan..."
      sudo systemctl start security-scan.service
      echo "Scan initiated. You will receive a notification when it completes."
    '')
    
    # View report script
    (writeShellScriptBin "view-security-report" ''
      #!/bin/sh
      if [ -f ~/security-report.txt ]; then
        ${pkgs.less}/bin/less ~/security-report.txt
      else
        echo "No security report found. Run 'run-security-scan' to generate one."
      fi
    '')
    
    # AIDE initialize script
    (writeShellScriptBin "init-aide-db" ''
      #!/bin/sh
      echo "Initializing AIDE database..."
      sudo ${pkgs.aide}/bin/aide --init
      sudo cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
      echo "AIDE database initialized."
    '')
  ];

  # Create necessary directories
  systemd.tmpfiles.rules = [
    "d /var/lib/security-scans 0750 root root -"
  ];
}
