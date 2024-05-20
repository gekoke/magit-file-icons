_: {
  perSystem =
    { lib, pkgs, ... }:
    {
      packages = rec {
        default = magit-file-icons;

        magit-file-icons = pkgs.emacsPackages.trivialBuild rec {
          pname = "magit-file-icons";
          version = "v1.0.2";

          src = ../.;

          packageRequires = [
            pkgs.emacsPackages.el-patch
            pkgs.emacsPackages.nerd-icons
            pkgs.emacsPackages.magit
          ];

          doCheck = true;

          nativeCheckInputs = [
            pkgs.git
            pkgs.emacs
          ] ++ packageRequires;

          checkPhase = ''
            emacs --batch -l ert -l magit-file-icons.el -l ./test/magit-file-icons-tests.el -f ert-run-tests-batch-and-exit
            git init
            emacs --batch -l ert -l magit-file-icons.el -l ./test/magit-file-icons-git-repo-tests.el -f ert-run-tests-batch-and-exit
          '';

          meta = {
            license = lib.licenses.gpl3;
          };
        };
      };
    };
}
