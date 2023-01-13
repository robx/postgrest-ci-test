# Create a bash script that is checked with shellcheck. You can either use it
# directly, or use the .bin attribute to get the script in a bin/ directory,
# to be used in a path for example.
{ bash
, runCommand
, stdenv
, writeTextFile
}:
{ name
, docs
, args ? [ ]
, positionalCompletion ? ""
, inRootDir ? false
, redirectTixFiles ? true
, withEnv ? null
, withPath ? [ ]
, withTmpDir ? false
}: text:
let
  bin =
    writeTextFile {
      inherit name;
      executable = true;
      destination = "/bin/${name}";

      text =
        ''
          #!${bash}/bin/bash
          set -euo pipefail
        ''

        + "(${text})";
    };

  script =
    runCommand name { inherit bin name; } "ln -s $bin/bin/$name $out";
in
script // { inherit bin; }
