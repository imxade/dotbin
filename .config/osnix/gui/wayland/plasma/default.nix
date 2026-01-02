{ lib, pkgs, config, ... }:

{
  imports = [ ../default.nix ];

  services = {
    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
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
    ];
  };
}
