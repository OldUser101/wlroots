{
  shortRev ? "dirty",
  ...
}:
rec {
  default = wlroots;

  wlroots = final: prev: {
    wlroots = prev.callPackage ./package.nix {
      version = "olduser101-git-${shortRev}";
    };
  };
}
