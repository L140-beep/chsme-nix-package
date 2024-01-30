{ qt5Full, nix, stdenv, fetchgit, runCommand }:

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
in rec { 

    libSource = fetchgit {
            url = "https://github.com/kruzhok-team/libcyberiadaml";
            rev = "d78e58130668a7cc1aa938ab775881e4090b25fd";
            sha256 = "sha256-OL02lRWGqcI32odBY5nr7EZicIkoR9BNG2Ac2ajdyEg=";
            # Почему-то не сработало, все равно всю репу выкачивает :(
            sparseCheckout = [
                "cyberiadaml.c"
                "cyberiadaml.h"
            ];
        }; 

    drv = stdenv.mkDerivation {
        pname = pname;
        version = version;
        system = builtins.currentSystem;
        src = fetchgit {
            url = "https://github.com/dralex/CyberiadaHSM-Editor.git";
            rev = "b2e0f5dce4edeb33e2d9171769ad9d9aac177019";
            sha256 = "sha256-zkmBgOXMPUOdb3z6LlmvLPOuM6sBxwEPm4WF7HEySNc=";  
        };

        buildInputs = [ qt5Full libSource ];

        configurePhase = ''
            ln -s ${libSource}/cyberiadaml.h ./cyberiadaml.h
            ln -s ${libSource}/cyberiadaml.c ./cyberiadaml.c
        '';
        buildPhase = ''
            ls
            qmake -makefile ./cyberiada.pro
            make
        '';
    };
}