self: super:
let
  runChecks = false;

  # Used in GHDL and GHDL-ls
  ghdlSrc = super.fetchFromGitHub {
    # 2021-03-05
    owner = "ghdl";
    repo = "ghdl";
    rev = "80b41f38598931c14db30232b8b38b12186c156d";
    sha256 = "1hznah2dgvyjshs1hijnq86irkmg56rn34rs41mabv3qq0a8xbcn";
  };

in
{

  # GHDL Newer then nixpkgs
  ghdl-llvm = super.ghdl-llvm.overrideAttrs (old: rec {

    version = "HEAD";
    src = ghdlSrc;

    doCheck = runChecks;

    # https://github.com/NixOS/nixpkgs/issues/97466
    propagatedBuildInputs = [ super.zlib ];

  });


  # Yosys with plugin for synthesizing
  # GHDL output
  yosys =
    let

      ghdl-yosys-plugin = super.fetchFromGitHub {
        # 2021-01-25
        owner = "ghdl";
        repo = "ghdl-yosys-plugin";
        rev = "cba859cacf8c6631146dbdaa0f297c060b5a68cd";
        sha256 = "01d9wb7sqkmkf2y9bnn3pmhy08khzs5m1d06whxsiwgwnjzfk9mx";
      };

    in
    super.yosys.overrideAttrs (old: rec {

      # Build Yosys with plugin
      # then `-m ghdl` is not needed
      postPatch = old.postPatch + ''
        mkdir -p frontends/ghdl
        cp -r ${ghdl-yosys-plugin}/src/* frontends/ghdl/
      '';

      makeFlags = old.makeFlags
        ++ [ "ENABLE_GHDL=1" "GHDL_PREFIX=${self.ghdl-llvm}" ];

      doCheck = runChecks;
    });



  symbiyosys = super.symbiyosys.overrideAttrs (old: rec {
    version = "2021.03.04";
    src = super.fetchFromGitHub {
      owner  = "YosysHQ";
      repo   = "SymbiYosys";
      rev    = "1ffef12cf1305da36c96b3f3cb20fdfacac820d2";
      sha256 = "1dx00z6c6hjkcklxa36pzj5n71xgzqds7y1izbgqzl5abxva0ag0";
    };
    # Symbiysys checks not working atm.
    # https://github.com/YosysHQ/SymbiYosys/pull/115
    # doCheck = true;
    # checkInputs = old.checkInputs ++ [ self.super_prove super.avy super.btor2tools];
  });

  # Super Prove
  super_prove = super.stdenv.mkDerivation rec {
    name = "super_prove-${version}";
    version = "2017.10.07";
    src = super.fetchurl {
      url =
        "https://downloads.bvsrc.org/super_prove/super_prove-hwmcc17_final-2-d7b71160dddb-Ubuntu_14.04-Release.tar.gz";
      sha256 = "0ay4m5lvwlazdq21wfng4nvlbvjq264rzzdcpsk9cp381lvnv9fq";
    };

    nativeBuildInputs = with super; [
      autoPatchelfHook
      python27
      readline
      zlib
      stdenv.cc.cc.lib
    ];

    installPhase = ''
      mkdir -p $out/libexec $out/bin
      mv bin $out/libexec
      mv lib $out/libexec
      cat > $out/bin/suprove <<EOF
      #!${super.runtimeShell}
      # `+` option is engine name
      tool=super_prove
      if [[ "\$1" != "\''${1#+}" ]]; then tool="\''${1#+}"; shift; fi
      exec $out/libexec/bin/\''${tool}.sh "\$@"
      EOF
      chmod +x $out/bin/suprove
    '';

    checkPhase = "${super.stdenv.shell} -n $out/bin/suprove";
  };


  # GHDL Language server and deps
  ghdl-ls = with super.pkgs.python3Packages;
    let
      pydecor = buildPythonPackage rec {
        pname = "pydecor";
        version = "2.0.1";
        src = super.fetchFromGitHub {
          owner = "mplanchard";
          repo = pname;
          rev = "v${version}";
          sha256 = "0g064ymmk6lzgwmzh068b82ddy5chy3gwb0003pr2705dngn2mxd";
        };

        doCheck = false;

        propagatedBuildInputs = [ six dill ];
      };

      pyVHDLModel = buildPythonPackage rec {
        pname = "pyVHDLModel";
        version = "0.8.0";
        src = super.fetchFromGitHub {
          owner = "VHDL";
          repo = pname;
          rev = "v${version}";
          sha256 = "0bqnkk3icrwkr2zjy8hmcdymyhcv7c6337zy0d9h2slwpmxpqql5";
        };

        propagatedBuildInputs = [ pydecor ];
      };


    in
    buildPythonPackage rec {

      name = "ghdl-ls";
      src = ghdlSrc;
      propagatedBuildInputs = [ pyVHDLModel pydecor ];
      buildInputs = [ self.ghdl-llvm ];

      # Dont build GHDL
      dontConfigure = true;

      # For shared lib
      checkInputs = [ self.ghdl-llvm ];
    };

}
