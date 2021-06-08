{}:
let
  pkgs = import
    (builtins.fetchTarball {
      name = "nixpkgs-unstable-2021-06-08";
      url =
        "https://github.com/nixos/nixpkgs/archive/3bc8e5cd23b84b2e149e7aaad57117da16a19e6f.tar.gz";
      sha256 = "16h0a45ncrjf3hcpqbkflmzfijgq2skkick6g2pr9ksy1rg0h6rb";
    }) { };

  fonts = pkgs.makeFontsConf {
    fontDirectories = with pkgs; [ source-sans-pro source-serif-pro iosevka ];
  };

in
pkgs.mkShell {

  # Fix for pandoc-plot when running in pure shell
  # LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  # LANG = "en_US.UTF-8";
  # LC_ALL = "en_US.UTF-8";
  FONTCONFIG_FILE = "${fonts}";

  buildInputs = with pkgs; [
    gnumake
    pandoc
    haskellPackages.pandoc-include-code
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
