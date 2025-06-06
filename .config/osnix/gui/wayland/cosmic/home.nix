{ lib, pkgs, config, ... }:

{
  home = {
    packages = with pkgs; [
      # Languages
      python3

      # Container
      wasmtime
      # wasmedge
      # container2wasm

      # Editor
      # helix
      # evil-helix

      # Monitor
      bottom

      # Utility
      zoxide

      # LSP
      # lldb
      # awk-language-server
      # nodePackages.bash-language-server
      # llvmPackages.clang
      # llvmPackages.clang-unwrapped
      # nodePackages.typescript-language-server
      # marksman
      # nimlsp
      # python3Packages.python-lsp-server
      # rust-analyzer-unwrapped
      # nodePackages.yaml-language-server

    ];
  };

  programs = { home-manager = { enable = true; }; };

}

