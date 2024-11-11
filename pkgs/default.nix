{pkgs}: let
  callPackage = pkgs.callPackage;
in {
  tinydfr = callPackage ./hardware/apple/tinydfr {};
}
