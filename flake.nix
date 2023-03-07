  {
    inputs =
      {
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
	implementation.url = "${IMPLEMENTATION}" ;
	test.url = "${TEST}" ;
	tester.url = "github:nextmoose/tester?rev=" e3cdd297e3cb2ba918111ea0ecd627defd2464ca;
      } ;
    outputs =
      { flake-utils , implementation , test } : flake-utils.lib.eachDefaultSystem ( system : builtins.getAttr system tester.lib implementation test ) ;
  }