  {
    inputs =
      {
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        implementation.url = "${IMPLEMENTATION}" ;
        nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843" ;
        test.url = "${TEST}" ;
        tester.url = "github:nextmoose/tester?rev=6eb1dbf7bce1b917eeb00294fbba0c7bd5b3c313" ;
      } ;
    outputs =
      { flake-utils , implementation , nixpkgs , self , test , tester } :
        flake-utils.lib.eachDefaultSystem
          (
            system :
              let
                pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                in
                  {
                    devShell =
                      pkgs.mkShell
                        { buildIncludes = [ ( pkgs.writeShellScriptBin "check" "${ pkgs.coreutils }/bin/echo ${ builtins.getAttr system tester.lib implementation test }" ) ] ; } ;
                  }
          ) ;
      }
