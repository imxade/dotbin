
(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu services)
             (guix gexp))


(home-environment
 (services
  (list
   (service home-zsh-service-type
            (home-zsh-configuration
             (zprofile (list (plain-file 
                             "$HOME/.zprofile" 
                             "bash-profile")))
             (zshrc (list (plain-file 
                             "$HOME/.zshrc" 
                             "zshrc"))))
))))
