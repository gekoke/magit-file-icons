;;; magit-file-icons.el --- Icons for file entries in Magit buffers -*- lexical-binding:t -*-


;; Package-Version: 0.0.1
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

(el-patch-define-template
 (defun magit-diff-insert-file-section)
 (format (el-patch-swap "%-10s %s" "%-10s %s %s") status (el-patch-add (nerd-icons-icon-for-file (or orig file)))
         (if (or (not orig) (equal orig file))
             file
           (format (el-patch-swap "%s -> %s" "%s -> %s %s") orig (el-patch-add (nerd-icons-icon-for-file file)) file))))

(defvar patched-functions '()
  "The Magit functions to should be patched.")

(when magit-file-icons-enable-diff-file-section-icons (push 'magit-diff-insert-file-section patched-functions))
;;;###autoload
(define-minor-mode magit-file-icons-mode
  "Prefix files with icons in Magit buffers."
  :after-hook
  (cond
   (magit-file-icons-mode
    (dolist (func patched-functions)
      (el-patch-eval-template func 'defun))
    (magit-refresh))
   ('deactivate
    (dolist (func patched-functions)
      (el-patch-unpatch func 'defun nil))
    (magit-refresh))))


(provide 'magit-file-icons)

;;; magit-file-icons.el ends here

