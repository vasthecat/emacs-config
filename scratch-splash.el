;; ---------------------------------------------------------------------
;; Copyright (C) 2020 - Nicolas .P Rougier 
;; Copyright (C) 2020 - N Λ N O developers 
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;; ---------------------------------------------------------------------
;;
;; Note: The screen is not shown if there are opened file buffers. For
;;       example, if you start emacs with a filename on the command
;;       line, the splash screen is not shown.
;;
;; This is based on some combination of:
;; - https://github.com/rougier/nano-emacs
;; - https://github.com/rougier/emacs-splash
(require 'cl-lib)

(defun scratch-splash ()
  "Emacs splash screen"
  
  (interactive)
  
  (let* ((splash-buffer  (get-buffer-create "*splash*"))
         (height         (round (- (window-body-height nil) 1) ))
         (width          (round (window-body-width nil)        ))
         (padding-center (- (/ height 2) 1)))
    
    ;; If there are buffer associated with filenames,
    ;; we don't show the splash screen.
    (if (eq 0 (length (cl-loop for buf in (buffer-list)
                              if (buffer-file-name buf)
                              collect (buffer-file-name buf))))
        (with-current-buffer splash-buffer
          (erase-buffer)
          
          (setq-local line-spacing 0)
          (setq-local vertical-scroll-bar nil)
          (setq-local horizontal-scroll-bar nil)
          (setq-local fill-column width)
          (face-remap-add-relative 'link :underline nil)

          (insert-char ?\n padding-center)

          (insert-text-button " www.gnu.org "
                              'action (lambda (_) (browse-url "https://www.gnu.org"))
                              'help-echo "Visit www.gnu.org website"
                              'follow-link t)
          (center-line) (insert "\n")
          (insert (concat
                   (propertize "GNU Emacs"  'face 'bold)
                   " version "
                   (format "%d.%d" emacs-major-version emacs-minor-version)))
          (center-line)

          (read-only-mode t)
          (display-buffer-same-window splash-buffer nil)
	  )
      )))

(provide 'scratch-splash)
