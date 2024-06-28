;; -*- lexical-binding: t; -*-

(require 'ert)
(require 'el-patch)
(require 'magit-file-icons)
(require 'nerd-icons)

(ert-deftest magit-file-icons-test-can-open-magit-status-buffer-while-in-minor-mode ()
  (magit-file-icons-mode +1)
  (magit-status-setup-buffer))

(ert-deftest magit-file-icons-test-can-enable-minor-mode-in-magit-status-buffer ()
  (magit-status-setup-buffer)
  (magit-file-icons-mode +1))

(ert-deftest magit-file-icons-test-can-disable-minor-mode-in-magit-status-buffer ()
  (magit-file-icons-mode +1)
  (magit-status-setup-buffer)
  (magit-file-icons-mode -1))

(ert-deftest magit-file-icons-test-can-toggle-minor-mode-in-magit-status-buffer ()
  (magit-file-icons-mode +1)
  (magit-status-setup-buffer)
  (magit-file-icons-mode 'toggle)
  (magit-file-icons-mode 'toggle))

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:

