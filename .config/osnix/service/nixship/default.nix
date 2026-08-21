{ config, lib, pkgs, inputs, ... }:

let
  nixship = inputs.nixship.packages.${pkgs.system}.default;
in
{
  # ==========================================================
  # NIX SHIP
  # ==========================================================

  users.groups.nixship = {};

  users.users.nixship = {
    isSystemUser = true;
    group = "nixship";

    home = "/var/lib/nixship";
    createHome = true;
  };


  # ==========================================================
  # PERSISTENT DATA
  # ==========================================================

  systemd.tmpfiles.rules = [
    "d /var/lib/nixship 0750 nixship nixship - -"
    "d /var/lib/nixship/data 0750 nixship nixship - -"
  ];


  # ==========================================================
  # SOURCE CHECKOUT
  #
  # The repo is cloned automatically on first boot.
  # ==========================================================

  systemd.services.nixship-repository = {
    description = "Nix Ship repository";

    wantedBy = [
      "multi-user.target"
    ];

    after = [
      "network-online.target"
    ];

    wants = [
      "network-online.target"
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };

    script = ''
      set -eu

      repo=/var/lib/nixship/repository

      if [ ! -d "$repo/.git" ]; then
        rm -rf "$repo"

        ${pkgs.git}/bin/git clone \
          https://github.com/imxade/nixship.git \
          "$repo"
      fi

      chown -R nixship:nixship "$repo"
    '';
  };


  # ==========================================================
  # NIX SHIP SERVICE
  # ==========================================================

  systemd.services.nixship = {
    description = "Nix Ship deployment control plane";

    wantedBy = [
      "multi-user.target"
    ];

    after = [
      "network-online.target"
      "nix-daemon.service"
      "nixship-repository.service"
    ];

    wants = [
      "network-online.target"
    ];

    requires = [
      "nixship-repository.service"
    ];

    serviceConfig = {
      Type = "simple";

      User = "nixship";
      Group = "nixship";

      WorkingDirectory = "/var/lib/nixship/repository";

      ExecStart = "${nixship}/bin/nixship";

      Restart = "on-failure";
      RestartSec = 5;

      Environment = [
        "NODE_ENV=production"
        "HOSTNAME=0.0.0.0"
        "PORT=3000"
        "PLATFORM_DATA_DIR=/var/lib/nixship/data"
      ];

      NoNewPrivileges = true;
    };
  };


  # ==========================================================
  # PERIODIC GIT UPDATE
  #
  # Pull upstream master every 30 minutes.
  # Restart Nix Ship only when the revision changes.
  # ==========================================================

  systemd.services.nixship-update = {
    description = "Update Nix Ship";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };

    script = ''
      set -eu

      repo=/var/lib/nixship/repository

      [ -d "$repo/.git" ] || exit 0

      cd "$repo"

      old="$(${pkgs.git}/bin/git rev-parse HEAD)"

      ${pkgs.git}/bin/git fetch --prune origin master

      ${pkgs.git}/bin/git reset --hard origin/master

      new="$(${pkgs.git}/bin/git rev-parse HEAD)"

      if [ "$old" != "$new" ]; then
        ${pkgs.systemd}/bin/systemctl restart nixship.service
      fi
    '';
  };


  systemd.timers.nixship-update = {
    description = "Periodically update Nix Ship";

    wantedBy = [
      "timers.target"
    ];

    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "30min";
      Persistent = true;
    };
  };


  # ==========================================================
  # FIREWALL
  # ==========================================================

  networking.firewall.allowedTCPPorts = [
    3000
  ];
}