{
  description = "My personal NUR repository";

  inputs = {
    corepkgs = {
      url = "github:ekala-project/corepkgs";
      flake = false;
    };
    nix-lib.url = "github:ekala-project/nix-lib";
    stdenv = {
      url = "github:ekala-project/stdenv";
      flake = false;
    };
  };

  outputs =
    inputs@{ self, corepkgs, ... }:
    let
      inherit (inputs.nix-lib) lib;

      systems = import "${inputs.stdenv}/systems" {
        inherit lib;
      };

      forAllSystems = lib.genAttrs systems.flakeExposed;
    in
    {
      legacyPackages = forAllSystems (
        system:
        import ./default.nix {
          pkgs = import corepkgs {
            inherit system;
          };
        }
      );
      packages = forAllSystems (
        system: lib.filterAttrs (_: v: lib.isDerivation v) self.legacyPackages.${system}
      );
    };
}
