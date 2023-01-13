{ bash
, runCommand
, stdenv
, writeTextFile
}:
let
  name = "postgrest-push-cachix";
  bin =
    writeTextFile {
      inherit name;
      executable = true;
      destination = "/bin/${name}";

      text =
        ''
          #!${bash}/bin/bash
          set -euo pipefail
          nix-instantiate \
            | while read -r drv; do
                nix-store -qR --include-outputs "$drv"
              done \
            | cachix push postgrest
        '';
    };

  script =
    runCommand name { inherit bin name; } "ln -s $bin/bin/$name $out";
in
script // { inherit bin; }
