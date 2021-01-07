{ }:
let

  pkgs = import (builtins.fetchTarball {
    name = "nixpkgs-unstable-2021-01-06";
    url =
      "https://github.com/nixos/nixpkgs/archive/4445bb7284f43feb2f3253d8fb1964f901df5ba1.tar.gz";
    sha256 = "1rz782whlll5ckc85qzndk5klygbjvxwnsgpm8lqqwb85y02s9cs";
  }) { };

  fonts = pkgs.makeFontsConf {
    fontDirectories = with pkgs; [ source-sans-pro source-serif-pro iosevka ];
  };

  pandoc-include-code = pkgs.haskellPackages.callCabal2nix "pandoc-include-code"
    (pkgs.fetchFromGitHub {
      owner = "owickstrom";
      repo = "pandoc-include-code";
      rev = "89c8465549960872257da993a399d978a269d6a6";
      sha256 = "07xj82injmcvqn0wz33qaqmvagfpbchk9s9gd6wcqdpmxg0ln5wb";
    }) { };

in pkgs.mkShell {

  # Fix for pandoc-plot when running in pure shell
  # LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  # LANG = "en_US.UTF-8";
  # LC_ALL = "en_US.UTF-8";
  FONTCONFIG_FILE = "${fonts}";

  buildInputs = with pkgs; [
    gnumake
    pandoc
    pandoc-include-code
    haskellPackages.pandoc-plot
    haskellPackages.pandoc-crossref
    graphviz
    gnome3.librsvg
    (texlive.combine {
      inherit (texlive)
        scheme-medium adjustbox babel-german background bidi collectbox csquotes
        everypage filehook footmisc footnotebackref framed fvextra letltxmacro
        ly1 mdframed mweights needspace pagecolor sourcecodepro sourcesanspro
        titling ucharcat ulem unicode-math upquote xecjk xurl zref circuitikz
        sectsty;
    })
  ];
}
