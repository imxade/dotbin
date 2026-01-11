{ lib, pkgs, config, ... }:

{
  imports = [ ../default.nix ];

  environment.systemPackages = with pkgs; [
    # sddm-sugar-dark
    kdePackages.qtmultimedia
    # squeekboard
    maliit-keyboard
  ];

  services = {
    desktopManager.plasma6.enable = true;
    libinput.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      # theme = "${pkgs.sddm-sugar-dark.override { variants = [ "qt6" ]; }}/share/sddm/themes/sugar-dark";
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
