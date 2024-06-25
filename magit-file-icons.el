;;; magit-file-icons.el --- Icons for file entries in Magit buffers -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Gregor Grigorjan

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Created: 14 May 2024

;; URL: https://github.com/gekoke/magit-file-icons
;; Package-Version: 1.0.2
;; Package-Requires: ((emacs "24.3") (magit "3.3.0") (nerd-icons "0.1.0") (el-patch "3.1"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Places icons next to file entries in Magit buffers based on file extension.
;; This is intended to improve visual clarity and ease of gleaning information.
;; Currently, the `nerd-icons' backend is the default, but it will fallback
;; to `all-the-icons' if nerd-icons is not found.

;;; Code:

(require 'el-patch)
(require 'el-patch-template)
(require 'magit)

(defgroup magit-file-icons nil
  "Show file icons in Magit buffers."
  :prefix "magit-file-icons-"
  :group 'appearance)

(defcustom magit-file-icons-enable-diff-file-section-icons t
  "Enable icons in diff file sections."
  :type 'boolean
  :group 'magit-file-icons)

(defcustom magit-file-icons-enable-untracked-icons t
  "Enable icons prefixing untracked files."
  :type 'boolean
  :group 'magit-file-icons)

(defcustom magit-file-icons-enable-diffstat-icons t
  "Enable icons in revision diffstats."
  :type 'boolean
  :group 'magit-file-icons)

(defcustom magit-file-icons-icon-backend 'nerd-icons
  "Icon backend for magit-file-icons. Set this to nil
if you want to customize `magit-file-icons-icon-for-file-func'
or `magit-file-icons-icon-for-dir-func'."
  :type 'symbol
  :group 'magit-file-icons)

(if (not (require 'nerd-icons nil t)) (funcall
                                       (lambda ()
                                        (require 'all-the-icons)
                                        (setq magit-file-icons-icon-backend 'all-the-icons))))

(defcustom magit-file-icons-icon-for-file-func nil
  "Icon for file function. Automatically set if
`magit-file-icons-icon-backend' is non-nil.
Customize using (fset 'magit-file-icons-icon-for-file-func 'custom-function)."
  :type 'symbol
  :group 'magit-file-icons)

(defcustom magit-file-icons-icon-for-dir-func nil
  "Icon for directory function. Automatically set if
`magit-file-icons-icon-backend' is non-nil.
Customize using (fset 'magit-file-icons-icon-for-file-func 'custom-function)."
  :type 'symbol
  :group 'magit-file-icons)

(defun magit-file-icons-refresh-backend ()
  "Refresh backend according to `magit-file-icons-icon-backend'.
Does not refresh if `magit-file-icons-icon-backend' is nil."
  (if magit-file-icons-icon-backend
  (if (eq magit-file-icons-icon-backend 'nerd-icons)
      (funcall (lambda ()
                 (fset 'magit-file-icons-icon-for-file-func 'nerd-icons-icon-for-file)
                 (fset 'magit-file-icons-icon-for-dir-func 'nerd-icons-icon-for-dir)))
      (funcall (lambda ()
                 (fset 'magit-file-icons-icon-for-file-func 'all-the-icons-icon-for-file)
                 (fset 'magit-file-icons-icon-for-dir-func 'all-the-icons-icon-for-dir))))))

(magit-file-icons-refresh-backend)

(el-patch-define-template
 (defun magit-diff-insert-file-section)
 (magit-file-icons-refresh-backend)
 (format (el-patch-swap "%-10s %s" "%-10s %s %s") status (el-patch-add (magit-file-icons-icon-for-file-func (or orig file)))
         (if (or (not orig) (equal orig file))
             file
           (format (el-patch-swap "%s -> %s" "%s -> %s %s") orig (el-patch-add (magit-file-icons-icon-for-file-func file)) file))))

(el-patch-define-template
 (defun magit-insert-untracked-files)
 (magit-file-icons-refresh-backend)
 (insert
  (propertize
   (el-patch-swap file
                  (format "%s %s"
                          (if (file-directory-p file)
                              (magit-file-icons-icon-for-dir-func file)
                            (magit-file-icons-icon-for-file-func file))
                          file))
   'font-lock-face 'magit-filename)
  ?\n))

(el-patch-define-template
 (defun magit-diff-wash-diffstat)
 (magit-file-icons-refresh-backend)
 (insert (propertize (el-patch-swap file (format "%s %s" (magit-file-icons-icon-for-file-func file) file)) 'font-lock-face 'magit-filename)
         sep cnt " "))

;;;###autoload
(define-minor-mode magit-file-icons-mode
  "Prefix files with icons in Magit buffers."
  :after-hook
  (cond
   (magit-file-icons-mode
    (when magit-file-icons-enable-diff-file-section-icons (el-patch-eval-template #'magit-diff-insert-file-section 'defun))
    (when magit-file-icons-enable-untracked-icons (el-patch-eval-template #'magit-insert-untracked-files 'defun))
    (when magit-file-icons-enable-diffstat-icons (el-patch-eval-template #'magit-diff-wash-diffstat 'defun)))
   ('deactivate
    (el-patch-unpatch #'magit-diff-insert-file-section 'defun nil)
    (el-patch-unpatch #'magit-insert-untracked-files 'defun nil)
    (el-patch-unpatch #'magit-diff-wash-diffstat 'defun nil))))

(provide 'magit-file-icons)

;;; magit-file-icons.el ends here

