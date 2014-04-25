(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(ido-mode t)

(require 'org-latex)
(setq org-export-latex-listings 'minted)
(add-to-list 'org-export-latex-packages-alist '("" "minted"))

(add-hook 'python-mode-hook '(lambda ()
    (local-set-key (kbd "RET") 'newline-and-indent)))

(setq org-src-fontify-natively t)

(setq htmlize-output-type 'css)

(add-to-list 'load-path "~/.emacs.d/evil") ; only without ELPA/el-get
(setq evil-want-C-i-jump nil)
(require 'evil)
(evil-mode 1)

(require 'table)
