{ lib, pkgs, config, ... }:

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
      # wasmedge
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
      # wofi
    ];
  };

  programs = { home-manager = { enable = true; }; };

}

