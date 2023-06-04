{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
    name = "hello";
    buildInputs = with pkgs; [
      clang
      clang-tools
    ];
}