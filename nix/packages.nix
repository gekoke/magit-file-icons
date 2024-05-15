_: {
  perSystem =
    { lib, pkgs, ... }:
    {
      packages = rec {
        default = magit-file-icons;

        magit-file-icons = pkgs.emacsPackages.trivialBuild rec {
          pname = "magit-file-icons";
          version = "v0.2.2";

          src = ../.;

          packageRequires = [
            pkgs.emacsPackages.el-patch
            pkgs.emacsPackages.magit
            pkgs.emacsPackages.nerd-icons
          ];

          doCheck = true;

          nativeCheckInputs = [
            pkgs.git
            pkgs.emacs
          ] ++ packageRequires;

          checkPhase = ''
            output=$(emacs --batch -L . -L test -l magit-file-icons-tests 2> >(grep invalid))
            if [[ $output ]]; then
                echo "Failed to validate templates. Output:"
                echo "$output"
                exit 1
            fi
          '';

          meta = {
            license = lib.licenses.gpl3;
          };
        };
      };
    };
}
