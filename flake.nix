{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs-channels/nixos-20.03";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = let
          beamPackages = pkgs.beam.packagesWith
            (pkgs.beam.interpreters.erlangR22_nox.override {
              enableHipe = false;
              wxSupport = false;
              installTargets = [ "install" ];
            });
        in flake-utils.lib.flattenTree rec {
          erlang-representer =
            beamPackages.callPackage ./nix/representer.nix { inherit self; };

          erlang-representer-docker = pkgs.callPackage ./nix/docker.nix {
            inherit self erlang-representer;
          };
        };
        defaultPackage = packages.erlang-representer;
      });
}
