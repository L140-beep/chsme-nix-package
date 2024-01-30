{ pkgs ? import <nixpkgs> {} }:

# Сюда надо передать libcyberiada.nix
pkgs.callPackage ./cyberiadahsmeditor.nix { }
# pkgs.callPackage ./libcyberiadaml.nix { }
