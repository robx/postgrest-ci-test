{ buildToolbox
, checkedShellScript
, nix
}:
let
  pushCachix =
    checkedShellScript
      {
        name = "postgrest-push-cachix";
        docs = ''
          Push all build artifacts to cachix.

          Requires authentication with `cachix authtoken ...`.
        '';
        inRootDir = true;
      }
      ''
        ${nix}/bin/nix-instantiate \
          | while read -r drv; do
              ${nix}/bin/nix-store -qR --include-outputs "$drv"
            done \
          | cachix push postgrest
      '';
in
buildToolbox
{
  name = "postgrest-cachix";
  tools = [
    pushCachix
  ];
  extra = { inherit pushCachix; };
}
