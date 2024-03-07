{ wrapQtAppsHook, pkg-config, qmake
, libxml2, qtbase, qtwayland, qttools 
, fetchgit, runCommand, stdenv
, mkDerivation
}:

let
    pname = "CyberiadaHSM-Editor";
    version = "0.0";
    name = "${pname}-${version}";

    meta = {
        description = "The Cyberiada Hierarchical State Machines Editor";
        longDescription = ''The Cyberiada Hierarchical State Machines Editor
        -The visual editor program for Cyberiada HSM graphs based on the Qt Framework.
        '';
    };
 
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

    libcyberiadaml = stdenv.mkDerivation {
        pname = "libcyberiadaml";
        version = "0.0";
        outputs = [ "bin" "dev" "out" ];
        system = builtins.currentSystem;
        src = fetchgit {
            url = "https://github.com/kruzhok-team/libcyberiadaml";
            rev = "d78e58130668a7cc1aa938ab775881e4090b25fd";
            sha256 = "sha256-OL02lRWGqcI32odBY5nr7EZicIkoR9BNG2Ac2ajdyEg=";  
        };
        buildInputs = [ libxml ];
        phases = [ "unpackPhase" "buildPhase" "installPhase" ];
        buildPhase = ''
            mkdir -p $out
            mkdir -p $dev
            mkdir -p $bin
            make
        '';

        installPhase = ''
            cp libcyberiadaml.a $dev/
            cp libcyberiadaml.a $bin/
            cp libcyberiadaml.a $out/
        '';
    };

    # TODO Создать libcyberiada.dev и положить туда .h .c файлы
    libSource = fetchgit {
            url = "https://github.com/kruzhok-team/libcyberiadaml";
            rev = "d78e58130668a7cc1aa938ab775881e4090b25fd";
            # sha256 = "sha256-OL02lRWGqcI32odBY5nr7EZicIkoR9BNG2Ac2ajdyEg=";
            sha256 = "sha256-cv/7Njnb5IOAzrGol8nGiRup4xTh0Ke4q1UCUADebz0=";
            # Почему-то не сработало, все равно всю репу выкачивает :(
            sparseCheckout = [
                "cyberiadaml.c"
                "cyberiadaml.h"
            ];
        }; 

in

mkDerivation {
        pname = pname;
        version = version;
        src = fetchgit {
            url = "https://github.com/dralex/CyberiadaHSM-Editor.git";
            rev = "b2e0f5dce4edeb33e2d9171769ad9d9aac177019";
            sha256 = "sha256-zkmBgOXMPUOdb3z6LlmvLPOuM6sBxwEPm4WF7HEySNc=";  
        };
        buildInputs = [ libxml2 qtbase libSource libcyberiadaml qtwayland ];
        nativeBuildInputs = [
            pkg-config qmake qttools
        ];
        configurePhase = ''
            # mkdir -p $bin
            mkdir -p $out
            ls ${libSource}
            ln -s ${libSource}/cyberiadaml.h ./cyberiadaml.h
            ln -s ${libSource}/cyberiadaml.c ./cyberiadaml.c
            mkdir ./cyberiadaml
            ln -s ${libcyberiadaml.bin}/libcyberiadaml.a ./cyberiadaml
            export QT_QPA_PLATFORM_PLUGIN_PATH=1
            qmake -makefile ./cyberiada.pro
        '';
        enableParallelBuilding = true;
        installPhase = ''
            mkdir -p $out/bin
            cp CyberiadaHSME $out/bin
        '';
}
