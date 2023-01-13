{ checkedShellScript
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
        nix-instantiate \
          | while read -r drv; do
              nix-store -qR --include-outputs "$drv"
            done \
          | cachix push postgrest
      '';
in
pushCachix
