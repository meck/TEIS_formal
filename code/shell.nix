{ pkgs ? (import ./nixpkgs.nix) }:

pkgs.mkShell {

  buildInputs = with pkgs; [

    # Main attractions
    ghdl-llvm
    yosys
    yosys-ghdl
    symbiyosys

    # Engines
    z3
    avy
    boolector
    yices
    # super_prove

    # Misc
    graphviz
    gnumake

    # Language server
    ghdl-ls

  ];
}
