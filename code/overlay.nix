self: super:
let
  runChecks = true;
  py3 = super.pkgs.python3Packages;

  # GHDL Newer version
  # 2021-03-30
  # Used in GHDL and GHDL-ls
  ghdlVersion = "HEAD";
  ghdlSrc = super.fetchFromGitHub {
    owner = "ghdl";
    repo = "ghdl";
    rev = "ef9cb64c5d334a3f0060d8245c8b77fb7daad62d";
    sha256 = "0xpcz8sx1n9ilczpa2vsg0n9cax3j2xrbw48m1rkzsqgm7rs3isv";
  };


  pydecor = with py3; buildPythonPackage rec {
    pname = "pydecor";
    version = "2.0.1";
    src = super.fetchFromGitHub {
      owner = "mplanchard";
      repo = pname;
      rev = "v${version}";
      sha256 = "0g064ymmk6lzgwmzh068b82ddy5chy3gwb0003pr2705dngn2mxd";
    };

    checkInputs = [ pytest ];
    doCheck = false;

    propagatedBuildInputs = [ six dill ];
  };

  pyVHDLModel = with py3; buildPythonPackage rec {
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
rec {

  ghdl = super.ghdl.overrideAttrs (old: rec {
    version = ghdlVersion;
    src = ghdlSrc;
    # https://github.com/NixOS/nixpkgs/issues/97466
    propagatedBuildInputs = [ super.zlib ];

    doCheck = runChecks;
    checkInputs = [ (super.python3.withPackages (ps: with ps; [ pytest pydecor pyVHDLModel ])) ];
    # https://github.com/ghdl/ghdl/issues/1255
    preCheck = old.preCheck or "" + ''
      make install.vpi.local
      patchShebangs  ./testsuite
    '';

  });

  # Newer version
  yosys-ghdl = super.yosys-ghdl.overrideAttrs (old: rec {
    src = super.fetchFromGitHub {
      owner = "ghdl";
      repo = "ghdl-yosys-plugin";
      rev = "98f4594b67ef650b115653185022e46876fb08ce";
      sha256 = "0gv2329dizwa4dxk6sgr7015bsjy5r48vmx22yfk5zy7r7whgxwi";
    };
  });


  # Wrap to not have to do "-m ghdl"
  yosys = super.symlinkJoin {
    name = "yosys";
    paths = [ super.yosys ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/yosys \
        --add-flags "-m ghdl"
    '';
  };

  # Newer version
  symbiyosys = super.symbiyosys.overrideAttrs (old: rec {
    version = "2021.03.04";
    src = super.fetchFromGitHub {
      owner = "YosysHQ";
      repo = "SymbiYosys";
      rev = "4db5d70c349a74c7febccb82671dcd75497b6c6c";
      sha256 = "1r5rj8af6xgy499zp3x5k7vk6w27c2b654wgc9479llsl0flqaqs";
    };
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
  ghdl-ls = with py3; buildPythonPackage rec {

    name = "ghdl-ls";
    src = ghdlSrc;
    propagatedBuildInputs = [ pyVHDLModel pydecor ];
    buildInputs = [ self.ghdl ];

    # Dont build GHDL
    dontConfigure = true;

    # For shared lib
    doCheck = runChecks;
    checkInputs = [ self.ghdl ];
  };

}
