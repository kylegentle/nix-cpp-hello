{
  description = "C++ Hello";

  inputs.nixpkgs.url = "nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });
    in
    {
      # A Nixpkgs overlay.
      overlay = final: prev: {
        hello = import ./. { pkgs = prev; };
      };

      packages = forAllSystems (system:
        {
          default = import ./default.nix { pkgs = nixpkgsFor.${system}; };
        }
      );

      devShells = forAllSystems (system:
        {
          default = (import ./shell.nix { pkgs = nixpkgsFor.${system};});
        }
      );
    };
}
