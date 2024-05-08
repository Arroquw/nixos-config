# This file should be included when using hm standalone
_: {
  nixpkgs = {
    #overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
