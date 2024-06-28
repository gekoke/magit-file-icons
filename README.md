
<h1 align="center">
    magit-file-icons.el
    <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="800px"/>
</h1>

Display icons for filenames in ![Magit](https://github.com/magit/magit) buffers!

<div>
    <a href="https://github.com/gekoke/magit-file-icons/actions"><img src="https://img.shields.io/github/actions/workflow/status/gekoke/magit-file-icons/ci.yaml?style=for-the-badge" alt="Build status"/></a>
    <a href="https://github.com/gekoke/magit-file-icons/releases/latest"><img src="https://img.shields.io/github/v/tag/gekoke/magit-file-icons.svg?label=release&sort=semver&color=blue&style=for-the-badge" alt="Version"/></a>
    <a href="https://opensource.org/license/gpl-3-0"><img src="https://img.shields.io/badge/license-GPLv3-orange.svg?style=for-the-badge" alt="License"></a>
</div>

# Preview
![Magit status buffer with file icons](./screenshots/status.png)

![Magit revision diffstat with file icons](./screenshots/diffstat.png)

# Installation
You can install this package from [MELPA](https://melpa.org/#/magit-file-icons).

For example, with `use-package`:

```elisp
(use-package magit-file-icons
  :ensure t
  :after magit
  :init
  (require 'nerd-icons)
  (magit-file-icons-mode 1)
  :custom
  ;; These are the default values:
  (magit-file-icons-enable-diff-file-section-icons t)
  (magit-file-icons-enable-untracked-icons t)
  (magit-file-icons-enable-diffstat-icons t))
```

If you are using some other method to install, you will need to ensure the following dependencies:

- `el-patch`
- `magit`
- Your own icons backend (i.e: `nerd-icons` or `all-the-icons`)

## Nix

Alternatively, you can use Nix. Currently, this will install it with the `nerd-icons` backend. This repository is a flake and outputs the following packages (versions omitted):

```
└───packages
    ├───aarch64-darwin
    │   ├───default: package 'emacs-magit-file-icons-vX.X.X'
    │   └───magit-file-icons: package 'emacs-magit-file-icons-vX.X.X'
    ├───aarch64-linux
    │   ├───default: package 'emacs-magit-file-icons-vX.X.X'
    │   └───magit-file-icons: package 'emacs-magit-file-icons-vX.X.X'
    ├───x86_64-darwin
    │   ├───default: package 'emacs-magit-file-icons-vX.X.X'
    │   └───magit-file-icons: package 'emacs-magit-file-icons-vX.X.X'
    └───x86_64-linux
        ├───default: package 'emacs-magit-file-icons-vX.X.X'
        └───magit-file-icons: package 'emacs-magit-file-icons-vX.X.X'
```

A minimal flake for creating an Emacs with the `magit-file-icons` package could look like this:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    magit-file-icons.url = "github:gekoke/magit-file-icons";
    magit-file-icons.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.emacsWithPackages (_: [
        inputs.magit-file-icons.packages.${system}.default
      ]);
    };
}
```

# Commentary

This package by default uses [nerd-icons.el](https://github.com/rainstormstudio/nerd-icons.el) to render icons. A custom icon backend can 
be used by customizing the `magit-file-icons-icon-for-file-func` and `magit-file-icons-icon-for-dir-func`. A minimal config for [all-the-icons](https://github.com/domtronn/all-the-icons.el) would include:
```elisp
(require 'all-the-icons)
(require 'magit-file-icons)
(setq magit-file-icons-icon-for-file-func 'all-the-icons-icon-for-file)
(setq magit-file-icons-icon-for-dir-func 'all-the-icons-icon-for-dir)
(magit-file-icons-mode 1)
```
