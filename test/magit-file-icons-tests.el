;; -*- lexical-binding: t; -*-

(require 'ert)
(require 'el-patch)
(require 'magit-file-icons)

(ert-deftest magit-file-icons-test-has-no-invalid-templates ()
  (el-patch-validate-all-templates))

(ert-deftest magit-file-icons-test-can-load-minor-mode-outside-of-git-repo ()
  (magit-file-icons-mode +1))

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:

