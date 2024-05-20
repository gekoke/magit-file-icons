;;; magit-file-icons.el --- Icons for file entries in Magit buffers -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Gregor Grigorjan

;; Author: Gregor Grigorjan <gregor@grigorjan.net>
;; Created: 14 May 2024

;; URL: https://github.com/gekoke/magit-file-icons
;; Package-Version: 1.0.0
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
;; Currently, only the `nerd-icons' backend is supported.

;;; Code:

(require 'el-patch)
(require 'el-patch-template)
(require 'magit)
(require 'nerd-icons)

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

(el-patch-define-template
 (defun magit-diff-insert-file-section)
 (format (el-patch-swap "%-10s %s" "%-10s %s %s") status (el-patch-add (nerd-icons-icon-for-file (or orig file)))
         (if (or (not orig) (equal orig file))
             file
           (format (el-patch-swap "%s -> %s" "%s -> %s %s") orig (el-patch-add (nerd-icons-icon-for-file file)) file))))

(el-patch-define-template
 (defun magit-insert-untracked-files)
 (insert
  (propertize
   (el-patch-swap file
                  (format "%s %s"
                          (if (file-directory-p file)
                              (nerd-icons-icon-for-dir file)
                            (nerd-icons-icon-for-file file))
                          file))
   'font-lock-face 'magit-filename)
  ?\n))

(el-patch-define-template
 (defun magit-diff-wash-diffstat)
 (insert (propertize (el-patch-swap file (format "%s %s" (nerd-icons-icon-for-file file) file)) 'font-lock-face 'magit-filename)
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

