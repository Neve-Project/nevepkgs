{
  description = "NevePkgs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
  in {
    packages = builtins.listToAttrs (map (system: {
        name = system;
        value = let
          pkgs = import nixpkgs {
            inherit system;
          };
          nevePackages = import ./pkgs {inherit pkgs;};
        in
          nevePackages;
      })
      systems);

    checks = builtins.listToAttrs (map (system: {
        name = system;
        value = let
          pkgs = import nixpkgs {
            inherit system;
          };
          nevePackages = import ./pkgs {inherit pkgs;};
        in
          builtins.listToAttrs (map (pkgName: {
            name = pkgName;
            value = nevePackages.${pkgName};
          }) (builtins.attrNames nevePackages));
      })
      systems);
  };
}
