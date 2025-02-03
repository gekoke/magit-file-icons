;; -*- lexical-binding: t; -*-

(require 'ert)
(require 'el-patch)
(require 'magit)
(require 'magit-file-icons)

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

(ert-deftest magit-file-icons-test-can-toggle-untracked-section ()
  (magit-file-icons-mode +1)
  (magit-status)
  (magit-jump-to-untracked)
  (magit-section-toggle (magit-current-section))
  (magit-section-toggle (magit-current-section)))

(ert-deftest magit-file-icons-test-can-toggle-unstaged-section ()
  (magit-file-icons-mode +1)
  (magit-status)
  (magit-jump-to-unstaged)
  (magit-section-toggle (magit-current-section))
  (magit-section-toggle (magit-current-section)))

(ert-deftest magit-file-icons-test-can-toggle-staged-section ()
  (magit-file-icons-mode +1)
  (magit-status)
  (magit-jump-to-staged)
  (magit-section-toggle (magit-current-section))
  (magit-section-toggle (magit-current-section)))

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:

