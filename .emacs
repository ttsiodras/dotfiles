; evil mode

; to install evil, just:
;     cd .emacs.d
;     git clone git://gitorious.org/evil/evil.git
;

(add-to-list 'load-path "~/.emacs.d/evil")
(setq evil-want-C-i-jump nil)
(require 'evil)
(evil-mode 1)

; org mode

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)


