_: {
  perSystem =
    { lib, pkgs, ... }:
    {
      packages = rec {
        default = magit-file-icons;

        magit-file-icons = pkgs.emacsPackages.trivialBuild rec {
          pname = "magit-file-icons";
          version = "v3.0.1";

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

          checkPhase =
            let
              createGitRepoStateScript = pkgs.writeShellScriptBin "init" ''
                git init
                git config user.email "john@example.com"
                git config user.name "John Doe"

                touch staged.txt unstaged.txt untracked.txt rename.txt
                git add staged.txt unstaged.txt rename.txt && git commit -m "init"

                mv rename.txt renamed.txt && git add rename.txt renamed.txt && git commit -m "rename"

                echo "staged changes" >> staged.txt && git add staged.txt

                echo "unstaged changes" >> unstaged.txt
              '';
            in
            ''
              emacs -l package -f package-initialize --batch -l ert -l magit-file-icons.el -l ./test/magit-file-icons-tests.el -f ert-run-tests-batch-and-exit
              ${createGitRepoStateScript}/bin/init # create staged changes (including file rename) and unstaged changes
              emacs -l package -f package-initialize --batch -l ert -l magit-file-icons.el -l ./test/magit-file-icons-git-repo-tests.el -f ert-run-tests-batch-and-exit
            '';

          meta = {
            license = lib.licenses.gpl3;
          };
        };
      };
    };
}
