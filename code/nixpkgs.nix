let
  nixpkgs = builtins.fetchTarball {
    name = "nixpkgs-unstable-2021-02-27";
    url =
      "https://github.com/nixos/nixpkgs/archive/f6b5bfdb470d60a876992749d0d708ed7b6b56ca.tar.gz";
    sha256 = "1rfsyz5axf2f7sc14wdm8dmb164xanbw7rcw6w127s0n6la17kq2";
  };
in (import nixpkgs) { overlays = [ (import ./overlay.nix) ]; }
