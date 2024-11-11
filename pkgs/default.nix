{pkgs}: let
  callPackage = pkgs.callPackage;
in {
  tiny-dfr = callPackage ./hardware/apple/tiny-dfr {};
  t2-linux = callPackage ./hardware/apple/t2-linux {};
}
