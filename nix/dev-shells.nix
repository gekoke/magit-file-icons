_: {
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShellNoCC { packages = [ pkgs.cask ]; };
    };
}
