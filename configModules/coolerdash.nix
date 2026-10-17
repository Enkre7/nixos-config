{ pkgs, ... }:

let
  coolerdash = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "coolerdash";
    version = "3.3.5";

    src = pkgs.fetchFromGitHub {
      owner = "damachine";
      repo = "coolerdash";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Q5BECYrOwKEUlYlosOBrdJbl2vJyKH9O4mWLe3H1ou4=";
    };

    nativeBuildInputs = with pkgs; [ pkg-config wrapGAppsNoGuiHook ];
    buildInputs = with pkgs; [ cairo fontconfig gdk-pixbuf jansson curl ];

    buildFlags = [ "bin/coolerdash" ];

    installPhase = ''
      runHook preInstall

      install -Dm755 bin/coolerdash $out/libexec/coolerdash/coolerdash
      mkdir -p $out/bin
      ln -s ../libexec/coolerdash/coolerdash $out/bin/coolerdash

      plugin=$out/share/coolerdash/plugin
      install -Dm644 etc/coolercontrol/plugins/coolerdash/manifest.toml $plugin/manifest.toml
      install -Dm644 etc/coolercontrol/plugins/coolerdash/config.json $plugin/config.json
      install -Dm644 etc/coolercontrol/plugins/coolerdash/ui/index.html $plugin/ui/index.html
      install -Dm644 images/shutdown.png $plugin/shutdown.png
      install -m644 README.md CHANGELOG.md VERSION -t $plugin

      substituteInPlace $plugin/manifest.toml $plugin/ui/index.html \
        --replace-quiet "{{VERSION}}" "${finalAttrs.version}"
      sed -i '/^executable = /d' $plugin/manifest.toml

      runHook postInstall
    '';
  });

  plugin = "${coolerdash}/share/coolerdash/plugin";
  pluginDir = "/var/lib/coolercontrol/plugins/coolerdash";
  pluginUser = "cc-plugin-user";
in
{
  environment.systemPackages = [ coolerdash ];

  systemd.tmpfiles.rules = [
    "d /var/lib/coolercontrol/plugins 0755 root root -"
    "d ${pluginDir} 0770 root ${pluginUser} -"
    "L+ ${pluginDir}/manifest.toml - - - - ${plugin}/manifest.toml"
    "L+ ${pluginDir}/ui - - - - ${plugin}/ui"
    "L+ ${pluginDir}/shutdown.png - - - - ${plugin}/shutdown.png"
    "L+ ${pluginDir}/README.md - - - - ${plugin}/README.md"
    "L+ ${pluginDir}/CHANGELOG.md - - - - ${plugin}/CHANGELOG.md"
    "L+ ${pluginDir}/VERSION - - - - ${plugin}/VERSION"
    "C+ ${pluginDir}/config.json - - - - ${../dotfiles/coolerdash/config.json}"
    "z ${pluginDir}/config.json 0600 ${pluginUser} ${pluginUser} -"
    "L+ ${pluginDir}/user-background-image - - - - ${../dotfiles/coolerdash/user-background-image.png}"
    "L+ ${pluginDir}/user-shutdown-image - - - - ${../dotfiles/coolerdash/user-shutdown-image.png}"
  ];

  users.users.${pluginUser} = {
    isSystemUser = true;
    group = pluginUser;
    description = "CoolerControl unprivileged plugin user";
  };
  users.groups.${pluginUser} = { };

  systemd.services.coolercontrold.restartTriggers = [ coolerdash ];

  systemd.services.cc-plugin-coolerdash = {
    description = "CoolerDash plugin for CoolerControl";
    after = [ "coolercontrold.service" ];
    partOf = [ "coolercontrold.service" ];
    wantedBy = [ "coolercontrold.service" ];
    environment.CC_LOG = "INFO";
    startLimitIntervalSec = 0;
    serviceConfig = {
      Type = "simple";
      User = pluginUser;
      Group = pluginUser;
      NoNewPrivileges = true;
      ExecStart = "${coolerdash}/libexec/coolerdash/coolerdash";
      Restart = "always";
      RestartSec = 5;
      TimeoutStopSec = 3;
    };
  };

  # CoolerControl only restarts plugins it manages itself, so restart on config changes
  systemd.paths.cc-plugin-coolerdash-reload = {
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathChanged = "${pluginDir}/config.json";
  };

  systemd.services.cc-plugin-coolerdash-reload = {
    description = "Restart CoolerDash after a configuration change";
    startLimitIntervalSec = 60;
    startLimitBurst = 5;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl try-restart cc-plugin-coolerdash.service";
    };
  };
}
