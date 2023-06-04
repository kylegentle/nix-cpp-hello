{ pkgs ? import <nixpkgs> {} }:


# Nix derivation for basic C++ project using clang
with pkgs; clangStdenv.mkDerivation {
  name = "hello";
  src = ./.;

  buildInputs = [
    clang
  ];

  installPhase = ''
    mkdir -p $out/bin
    mv hello $out/bin/hello
  '';
}
