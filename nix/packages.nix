_: {
  perSystem =
    { lib, pkgs, ... }:
    {
      packages = rec {
        default = magit-file-icons;

        magit-file-icons = pkgs.emacsPackages.trivialBuild {
          pname = "magit-file-icons";
          version = "v0.0.1";

          src = ../.;

          packageRequires = [
            pkgs.emacsPackages.el-patch
            pkgs.emacsPackages.magit
            pkgs.emacsPackages.nerd-icons
          ];
        };
      };
    };
}
