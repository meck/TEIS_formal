# let
#   nixpkgs = builtins.fetchTarball {
#     name = "nixpkgs-unstable-2021-03-04";
#     url =
#       "https://github.com/nixos/nixpkgs/archive/d496205cf22c3079461d868ea3198d42ded59287.tar.gz";
#     sha256 = "1yjsapz3q6gc3ckd5cf4dwjqh94y9wpn0gjp69jr2zr8ibnbgp25";
#   };
# in (import nixpkgs) { overlays = [ (import ./overlay.nix) ]; }
import <nixpkgs> { overlays = [ (import ./overlay.nix) ]; }
