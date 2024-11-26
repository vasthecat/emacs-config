;; Set up benchmark-init of initialization early inside init.el to correctly benchmark load time
(when (package-installed-p 'benchmark-init)
  (require 'benchmark-init)
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(setq checksum-path (expand-file-name ".config-checksum" user-emacs-directory))
(setq config-path (expand-file-name "config.org" user-emacs-directory))
(setq config-untangled-path (expand-file-name "config.el" user-emacs-directory))

;; Since config is residing inside one file, I can calculate its checksum and tangle config.org only
;; when it was changed. This way loading is significantly faster.
(setq new-checksum (car (split-string (shell-command-to-string (concat "md5sum --zero " config-path)))))
(setq saved-checksum "")
(when (file-exists-p checksum-path)
  (setq saved-checksum (with-temp-buffer
                         (insert-file-contents checksum-path)
                         (buffer-string))))
(if (string-equal new-checksum saved-checksum)
    (load-file config-untangled-path)
  (progn
    (write-region new-checksum nil checksum-path)
    (setq org-modules '(org-id ol-info org-protocol))
    (org-babel-load-file config-path)))

