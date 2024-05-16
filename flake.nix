{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    systems.url = "github:nix-systems/default";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        ./nix/dev-shells.nix
        ./nix/packages.nix
        (
          { inputs, ... }:
          {
            perSystem =
              { pkgs, system, ... }:
              {
                _module.args.pkgs = import inputs.nixpkgs {
                  inherit system;
                  overlays = [ inputs.emacs-overlay.overlays.default ];
                };
              };
          }
        )
      ];
    };
}
