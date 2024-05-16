;; -*- lexical-binding: t; -*-

(require 'ert)
(require 'el-patch)
(require 'magit-file-icons)

(ert-deftest magit-file-icons-should-have-no-invalid-templates ()
  (el-patch-validate-all-templates))

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:

