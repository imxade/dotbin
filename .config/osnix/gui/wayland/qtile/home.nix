
 { lib
 , pkgs
 , config
 , ...
 }:

 {
    home = {
            packages = with pkgs; [
            # Browser
            # mullvad-browser
            # brave

            # Language
            # nim-unwrapped
            # nim-unwrapped-2
            # nimble
            # openssl
            python3
            # gcc_multi
            # gcc-unwrapped

            # Container
            # wasm3
            wasmtime
            wasmedge
            container2wasm
            
            # Editor
            # helix
            
            # Monitor
            bottom

            # LSP
            # lldb
            # awk-language-server
            # nodePackages.bash-language-server
            llvmPackages.clang
            # llvmPackages.clang-unwrapped
            # nodePackages.typescript-language-server
            # marksman
            # nimlsp
            # python3Packages.python-lsp-server
            # rust-analyzer-unwrapped
            # nodePackages.yaml-language-server

            # Launcher
            wofi
    	    ];

    	    # Profile Wide Cursor Theme, so Applications will Not be Able to Choose their Own
#   	    pointerCursor = {
#   		name = "Dracula-cursors";
#   		package = pkgs.dracula-theme;
#   		size = 14;
#   	    };
    };

    programs = {
            home-manager = {
        	    enable = true;
            };
    };

    # Using Bluetooth headset buttons to control media player
#   systemd = {
#           user = {
#       	    services = {
#       		    mpris-proxy = {
#       			    Unit = {
#       				    Description = "Mpris proxy";
#       				    After = [
#       				      "network.target"
#       				      "sound.target" 
#       				    ];
#       			    };
#       		    };
#       		    ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
#       		    Install = {
#       			    WantedBy = [
#       			      "default.target"
#       			    ];
#       		    };
#       	    };
#           };
#   };

    # GTK Theme
#   gtk = {
#	    enable = true;
#	    theme = {
#   		name = "Dracula-cursors";
#   		package = pkgs.dracula-theme;
#	    };
#	    theme = {
#		name = "Canta-dark";
#		package = pkgs.canta-theme;
#	    };
#	    iconTheme = {
#		name = "Papirus-Dark";
#		package = pkgs.papirus-icon-theme;
#	    };
#	    font = {
#		name = "Hermit Nerd Font Mono Medium";
#	    };
#   };
 }

