{ pkgs ? (import ./nixpkgs.nix) }:

pkgs.mkShell {

  buildInputs = with pkgs; [

    # Main attractions
    ghdl-llvm
    yosys
    symbiyosys

    # Engines
    z3
    avy
    boolector
    yices
    super_prove

    # Misc
    graphviz
    gnumake

    # TODO symbiyosys shebangs
    # are not patched correctly
    # python3

    # Language server
    # ghdl-ls

  ];
}
