{pkgs}: let
  callPackage = pkgs.callPackage;
in {
  tinydfr = callPackage ./hardware/apple/tinydfr {};
  t2-kernel = callPackage ./hardware/apple/t2-kernel {};
}
