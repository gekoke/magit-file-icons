_: {
  perSystem =
    { lib, pkgs, ... }:
    {
      packages = rec {
        default = magit-file-icons;

        magit-file-icons = pkgs.emacsPackages.trivialBuild rec {
          pname = "magit-file-icons";
          version = "v1.0.0";

          src = ../.;

          packageRequires = [
            pkgs.emacsPackages.el-patch
            pkgs.emacsPackages.nerd-icons
          ];

          doCheck = true;

          nativeCheckInputs = [
            pkgs.git
            pkgs.emacs
            pkgs.emacsPackages.magit
          ] ++ packageRequires;

          checkPhase = ''
            git init # need to be in repository for Magit tests to not fail
            emacs --batch -l ert -l magit-file-icons.el -l ./test/magit-file-icons-tests.el -f ert-run-tests-batch-and-exit
          '';

          meta = {
            license = lib.licenses.gpl3;
          };
        };
      };
    };
}
