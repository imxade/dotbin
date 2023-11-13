
(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu services)
             (gnu packages admin)
             (guix gexp))


(home-environment
 (packages (list "bottom"
                 "neofetch"
                 "git"
                 "qtile"
                 "flatpak"
                 "ntfs-3g"
                 "zsh"
                 "clang"
                 "gammastep"
                ))
 (services
  (list
   (service home-zsh-service-type
            (home-zsh-configuration
             (guix-defaults? #t)
             (zprofile (list (plain-file 
                             "$HOME/.zprofile" 
                             "bash-profile")))
             (zshrc (list (plain-file 
                             "$HOME/.zshrc" 
                             "zshrc")))
  ))))
