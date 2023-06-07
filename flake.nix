{
  description = "C++ Hello";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    mini-compile-commands = {
      url = "github:danielbarter/mini_compile_commands";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, mini-compile-commands }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        {
          default = import ./default.nix { pkgs = nixpkgsFor.${system}; };
        }
      );

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system}; in rec {
          mcc-env = (pkgs.callPackage mini-compile-commands {}).wrap pkgs.clangStdenv;
          default = (import ./shell.nix { inherit pkgs mcc-env; });
        }
      );
    };
}
