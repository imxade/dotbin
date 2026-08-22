{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [ ../default.nix ];

  environment.systemPackages = with pkgs; [
    kdePackages.qtmultimedia
    maliit-keyboard
    # sddm-sugar-dark
    # squeekboard
    # kdePackages.qtvirtualkeyboard
  ];

  systemd.services.display-manager.environment = {
    QT_IM_MODULE = "qtvirtualkeyboard";
    QT_VIRTUALKEYBOARD_DESKTOP_DISABLE = "0";
  };

  services = {
    desktopManager.plasma6.enable = true;
    libinput.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      settings = {
        General = {
          InputMethod = "qtvirtualkeyboard";
        };
      };
      extraPackages = [
        pkgs.kdePackages.qtvirtualkeyboard
      ];
    };
  };

  environment = {
    # Explicitly remove KDE terminal and friends
    plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      elisa # Simple music player aiming to provide a nice experience for its users
      kdepim-runtime # Akonadi agents and resources
      kmahjongg # KMahjongg is a tile matching game for one or two players
      kmines # KMines is the classic Minesweeper game
      konversation # User-friendly and fully-featured IRC client
      kpat # KPatience offers a selection of solitaire card games
      ksudoku # KSudoku is a logic-based symbol placement puzzle
      ktorrent # Powerful BitTorrent client
      kate
      okular

    ];
  };
}
