let
  nixpkgs = (builtins.fetchTarball {
    name = "nixpkgs-unstable-2021-06-08";
    url =
      "https://github.com/nixos/nixpkgs/archive/3bc8e5cd23b84b2e149e7aaad57117da16a19e6f.tar.gz";
    sha256 = "16h0a45ncrjf3hcpqbkflmzfijgq2skkick6g2pr9ksy1rg0h6rb";
  });
in
(import nixpkgs) { overlays = [ (import ./overlay.nix) ]; }
