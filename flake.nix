  {
    inputs =
      {
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        implementation.url = "${IMPLEMENTATION}" ;
        test.url = "${TEST}" ;
        tester.url = "github:nextmoose/tester?rev=aac01d11f1f1c31092ce5f6bd0cacf589d6804c8" ;
      } ;
    outputs =
      { flake-utils , implementation , self , test , tester } : flake-utils.lib.eachDefaultSystem ( system : builtins.getAttr system tester.lib implementation test ) ;
  }
