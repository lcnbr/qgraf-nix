# qgraf-nix

QGRAF packaged as a Nix flake from the GoSam-hosted tarball.

## Build
```sh
# First build will fail with a hash mismatch; copy the "got:" hash into pkgs/qgraf.nix
NIXPKGS_ALLOW_UNFREE=1 nix build

# Then
./result/bin/qgraf
