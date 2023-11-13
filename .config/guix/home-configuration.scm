
(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu services)
             (guix gexp))


(home-environment
 (services
  (list
   (service home-zsh-service-type
            (home-zsh-configuratizsh
             (zprofile (list (local-file 
                             "$HOME/.zprofile" 
                             "zsh-profile")))
             (zshrc (list (local-file 
                             "$HOME/.zshrc" 
                             "zshrc"))))
))))
