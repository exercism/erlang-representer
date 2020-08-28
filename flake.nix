{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs-channels/nixos-20.03";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree {
          erlang-representer =
            pkgs.beamPackages.callPackage ./nix/representer.nix {
              inherit self;
            };
        };
        defaultPackage = packages.erlang-representer;
      });
}
