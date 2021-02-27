{}:
let
  pkgs = import
    (builtins.fetchTarball {
      name = "nixpkgs-unstable-2021-02-27";
      url =
        "https://github.com/nixos/nixpkgs/archive/f6b5bfdb470d60a876992749d0d708ed7b6b56ca.tar.gz";
      sha256 = "1rfsyz5axf2f7sc14wdm8dmb164xanbw7rcw6w127s0n6la17kq2";
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
