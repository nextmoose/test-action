{ pkgs ? import ( fetchTarball "https://github.com/NixOS/nixpkgs/archive/bf972dc380f36a3bf83db052380e55f0eaa7dcb6.tar.gz" ) {} } :
  pkgs.mkShell
    {
      shellHook =
        let
          dollar = expression : builtins.concatStringsSep "" [ "$" "{" expression "}" ] ;
	  print =
	    variables :
	      let
	        mapper =
		  variable :
		    ''
		      ${ pkgs.coreutils }/bin/echo -en "\n\n${ variable }=\"${ dollar variable }\"\n\n"
	            '' ;
		in pkgs.writeShellScriptBin "print" ( builtins.concatStringsSep "\n" ( builtins.map mapper variables ) ) ;
          in
            ''
	      ${ print [ "IMPLEMENTATION_URL" "IMPLEMENTATION_POSTULATE" "TEST_URL" "TEST_POSTULATE" "TEST_REV" "TEST_DEFECT" "POSTULATE" "GITHUB_WORKSPACE" ] }/bin/print &&
              WORK_DIR=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
              cd ${ dollar "WORK_DIR" } &&
              ${ pkgs.git }/bin/git init &&
              ${ pkgs.git }/bin/git config user.name "No One" &&
              ${ pkgs.git }/bin/git config user.email "no@one" &&
              ${ pkgs.nix }/bin/nix flake init &&
              if [ ${ dollar "IMPLEMENTATION_POSTULATE" } == true ]
              then
                export IMPLEMENTATION=${ dollar "GITHUB_WORKSPACE" }
              else
                export IMPLEMENTATION=${ dollar "IMPLEMENTATION_URL" }
              fi &&
              if [ ${ dollar "TEST_POSTULATE" } == true ]
              then
                export TEST=${ dollar "GITHUB_WORKSPACE" }
              elif [ -z "${ dollar "IMPLEMENTATION_REV" }" ]
              then
                TEST=${ dollar "TEST_URL" }
              else
                TEST=${ dollar "TEST_URL" }?rev=${ dollar "TEST_REV" }
              fi &&
	      ${ print [ "IMPLEMENTATION" "TEST" ] }/bin/print &&
              ${ pkgs.gnused }/bin/sed \
                -e "s#\${ dollar "IMPLEMENTATION" }#${ dollar "IMPLEMENTATION" }#" \
                -e "s#\${ dollar "TEST" }#${ dollar "TEST" }#" \
                -e "wflake.nix" \
                "${ dollar "ACTION_PATH" }/flake.nix" &&
              ${ pkgs.git }/bin/git add flake.nix &&
              ${ pkgs.git }/bin/git commit --all --allow-empty-message --message "" &&
              if [ ${ dollar "POSTULATE" } == true ]
              then
                export OBSERVED_DEFECT="$( ${ pkgs.nix }/bin/nix develop --command check )" &&
		export EXPECTED_DEFECT="${ dollar "TEST_DEFECT" }" &&
		${ print [ "OBSERVED_DEFECT" "EXPECTED_DEFECT" ] }/bin/print &&
		if [ "${ dollar "OBSERVED_DEFECT" }" == "${ dollar "EXPECTED_DEFECT" }" ]
		then
		  ${ pkgs.coreutils }/bin/echo PASSED
		else
		  ${ pkgs.coreutils }/bin/echo FAILED &&
		  exit 64
		fi
              fi	
            '' ;
    }
