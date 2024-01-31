{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./cyberiadahsmeditor.nix {  }
# Сюда надо передать libcyberiada.nix
# pkgs.callPackage ./libcyberiadaml.nix { }
