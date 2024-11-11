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
    neveOverlay = final: prev: {
      # Importa tutti i pacchetti dalla directory pkgs
      nevePackages = import ./pkgs {inherit final prev;};
    };
  in rec {
    # Esponi l'overlay sotto 'overlays.default' per l'utilizzo in altri progetti
    overlays = {
      default = neveOverlay;
    };

    # Per ogni sistema, importa nixpkgs con l'overlay e esponi i pacchetti
    packages = builtins.listToAttrs (map (system: {
        name = system;
        value = let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [neveOverlay];
          };
        in
          # Esponi tutti i pacchetti presenti in nevePackages
          pkgs.nevePackages
          // {
            # Imposta il pacchetto predefinito
            default = pkgs.nevePackages.tinydfr;
          };
      })
      systems);

    # Definisci i checks per costruire tutti i pacchetti su tutti i sistemi
    checks = builtins.listToAttrs (map (system: {
        name = system;
        value = let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [neveOverlay];
          };
          nevePkgs = pkgs.nevePackages;
        in
          # Crea un insieme di derivazioni per tutti i pacchetti in nevePackages
          builtins.listToAttrs (map (pkgName: {
            name = pkgName;
            value = nevePkgs.${pkgName};
          }) (builtins.attrNames nevePkgs));
      })
      systems);
  };
}
