; (define-public base-operating-system

;; Import nonfree linux module.
(use-modules (nongnu packages linux)
             (nongnu system linux-initrd))

  (operating-system
    (host-name "guix")
    (timezone "America/Los_Angeles")
    (locale "en_US.utf8")

    ;; Use non-free Linux and firmware
    (kernel linux)
    (firmware (list linux-firmware))
    (initrd microcode-initrd)

    ;; Choose US English keyboard layout. 
    (keyboard-layout (keyboard-layout "us"))

    ;; Guix doesn't like it when there isn't a file-systems
    ;; entry, so add one that is meant to be overridden
    ; (file-systems (cons*
    ;                (file-system
    ;                  (mount-point "/tmp")
    ;                  (device "none")
    ;                  (type "tmpfs")
    ;                  (check? #f))
    ;                %base-file-systems))
                    
    (file-systems
      (append (list
                   (file-system
                     (device (uuid "ce399868-793b-4e2e-a0b0-e6ba1d66819b"))
                     (mount-point "/home")
                     (type "btrfs")
                     (options "subvol=home")))))

    (users (cons (user-account
                  (name "x")
                  (comment "x")
                  (group "users")
                  (home-directory "/home/x")
                  (supplementary-groups '(
                                          "wheel"     ;; sudo
                                          "netdev"    ;; network devices
                                          "kvm"
                                          "tty"
                                          "input"
                                          "docker"
                                          "realtime"  ;; Enable realtime scheduling
                                          "lp"        ;; control bluetooth devices
                                          "audio"     ;; control audio devices
                                          "video"
                                          "seat"      ;; access to shared devices
                                          "cdrom"
                                          )))  ;; control video devices

                 %base-user-accounts))

    ;; Add the 'realtime' group
    (groups (cons (user-group (system? #t) (name "realtime"))
                  %base-groups))

    ;; Install bare-minimum system packages
    (packages (append (list
                        git
                        bluez-alsa
                        tlp
                        nss-certs     ;; for HTTPS access
                        gvfs)         ;; for user mounts
                    %base-packages))

    ;; Use the "desktop" services, which include the X11 log-in service,
    ;; networking with NetworkManager, and more
    (services (cons* 
                    (service tlp-service-type
                             (tlp-configuration
                                (cpu-boost-on-ac? #t)
                                (wifi-pwr-on-bat? #t)))
                    ; (service docker-service-type)
                    ; (service libvirt-service-type
                    ;          (libvirt-configuration
                    ;           (unix-sock-group "libvirt")
                    ;           (tls-port "16555")))
                    ; (service cups-service-type
                    ;          (cups-configuration
                    ;            (web-interface? #t)
                    ;            (extensions
                    ;              (list cups-filters))))
                    ; (service nix-service-type)
                    (service seatd-service-type)
                    (bluetooth-service #:auto-enable? #t)
                            %my-desktop-services)))

    ;; Allow resolution of '.local' host names with mDNS
    ; (name-service-switch %mdns-host-lookup-nss))
; )
