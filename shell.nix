{ pkgs ? import <nixpkgs> {}
, mcc-env }:

let 
  mccShell = pkgs.mkShell.override { stdenv = mcc-env; };
in
mccShell {
    name = "hello";
    buildInputs = with pkgs; [
      clang-tools
    ];
}
