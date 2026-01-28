{
  description = "QGRAF packaged from the GoSam tarball";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    lib = nixpkgs.lib;
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = f: lib.genAttrs systems (system: f system);
  in {
    # Allow: inputs.qgraf.url = "github:<you>/qgraf-nix";
    overlays.default = final: prev: {
      qgraf = final.callPackage ./pkgs/qgraf.nix {};
    };

    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        };
      in {
        default = pkgs.qgraf;
        qgraf = pkgs.qgraf;
      }
    );

    # `nix run github:<you>/qgraf-nix`
    apps = forAllSystems (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.qgraf}/bin/qgraf";
      };
    });

    # `nix develop`
    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = pkgs.mkShell {
          packages = [pkgs.gfortran pkgs.nix pkgs.git];
        };
      }
    );

    # `nix flake check`
    checks = forAllSystems (system: {
      build = self.packages.${system}.qgraf;
    });
  };
}
