{libxml2, nix, stdenv, fetchgit, runCommand}:

let
  pname = "libcyberiadaml";
  version = "0.0";
  name = "${pname}-${version}";

  meta = {
    description = "The Cyberida State Machine Library";
    longDescription = ''The C library for processing CyberiadaML 
    - the version of GraphML for storing state machine graphs used by the Cyberiada Project,
    the Berloga Project games and the Orbita Simulator.
    '';
  };

in rec {
    # TODO Мб в отдельный файлик
    libxml = stdenv.mkDerivation {
        name = "libxml" ;
        system = builtins.currentSystem;
        outputs = [ "bin" "dev" "out" ];
        phases = ["buildPhase"];
        buildPhase =
        ''echo "my command out = $out"
            echo ${libxml2.dev}
            mkdir -p $out
            mkdir -p $dev
            mkdir -p $bin
            ln -s ${libxml2.dev}/include/libxml2 $dev/include
            ln -s ${libxml2.dev}/lib $dev/lib
        ''; 
    };
    drv = stdenv.mkDerivation {
        pname = pname;
        version = version;
        outputs = [ "bin" "dev" "out" ];
        src = fetchgit {
            url = "https://github.com/kruzhok-team/libcyberiadaml";
            rev = "d78e58130668a7cc1aa938ab775881e4090b25fd";
            sha256 = "sha256-OL02lRWGqcI32odBY5nr7EZicIkoR9BNG2Ac2ajdyEg=";  
        };
        buildInputs = [ libxml ];
        phases = [ "unpackPhase" "buildPhase" ];
        buildPhase = ''
            mkdir -p $out
            mkdir -p $dev
            mkdir -p $bin
            make
        '';
    };
}