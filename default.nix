let
  # Import sources
  sources = import ./nix/sources.nix;

   kata-containers = ./applications/virtualization/kata-containers { };

  pkgs = import sources.nixpkgs {
    overlays = [ (import ./applications/virtualization/kata-containers/overlay.nix ) ];
  };
in pkgs
