{
  final,
  prev,
}: let
  callPackage = final.callPackage;
in {
  tinydfr = callPackage ./hardware/apple/tinydfr {};
}
