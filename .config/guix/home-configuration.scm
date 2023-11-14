
(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu services)
             (gnu packages)
             (guix gexp))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (specifications->packages (list "htop"
                                            "neofetch"
                                            )))

 (services
  (list
   (service home-zsh-service-type
            (home-zsh-configuration
             (zprofile (list (local-file 
                             "$HOME/.zprofile" 
                             "zsh-profile")))
             (zshrc (list (local-file 
                             "$HOME/.zshrc" 
                             "zshrc"))))
))))
