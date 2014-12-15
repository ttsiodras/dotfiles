;;;;;;;;;;;
; evil mode
;;;;;;;;;;;

; to install evil, just:
;     cd .emacs.d
;     git clone git://gitorious.org/evil/evil.git
;

(add-to-list 'load-path "~/.emacs.d/evil")
(setq evil-want-C-i-jump nil)
(require 'evil)

;;;;;;;;;;;;;
; evil-leader
;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/evil-leader")
(require 'evil-leader)
(global-evil-leader-mode)

;; Start in evil mode
(evil-mode 1)

;; Setup Scala type inspection via leader-t
(evil-leader/set-key "t" 'ensime-inspect-type-at-point)

;; Close window with C-F12
(define-key evil-normal-state-map (kbd "C-<f12>") 'evil-delete-buffer)

;; spawn shell with F2 in current folder
;; ;; deprecated, too strong:(global-set-key [f2] 'shell)
(define-key evil-normal-state-map (kbd "<f2>") 'shell)

;; TAB and S-TAB cycle between buffers
(define-key evil-normal-state-map (kbd "<tab>") 'evil-next-buffer)
(define-key evil-normal-state-map (kbd "<backtab>") 'evil-prev-buffer)

;;;;;;;;;;
; org mode
;;;;;;;;;;

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;;;;;;;;;
; ensime
;;;;;;;;;;

;; if you're new to the MELPA package manager, include this in your `~/.emacs` file to add it
(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
;; restart emacs and then do M-x package-install [RETURN] ensime [RETURN]

;; If necessary, add JDK_HOME or JAVA_HOME to the environment
;; (setenv "JDK_HOME" "/path/to/jdk")

;; If necessary, make sure "sbt" and "scala" are in the PATH environment
;; (setenv "PATH" (concat "/path/to/sbt/bin:" (getenv "PATH")))
;; (setenv "PATH" (concat "/path/to/scala/bin:" (getenv "PATH")))

;; You can also customize `ensime-inf-get-project-root' and `ensime-inf-get-repl-cmd-line'
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;; (add-hook 'ensime-source-buffer-saved-hook 'ensime-show-all-errors-and-warnings)

(defun current-buffer-extension ()
  (if (stringp (buffer-file-name))
    (file-name-extension buffer-file-name) 
    "Unknown"))

(defun handle-f7 ()
  (interactive)
  (if (string= (current-buffer-extension) "scala")
    (ensime-typecheck-all)))

(defun handle-goto-def ()
  (interactive)
  (if (string= (current-buffer-extension) "scala")
    (ensime-edit-definition)))

(defun handle-navigate-back ()
  (interactive)
  (if (string= (buffer-name) "*Inspector*")
    (ensime-inspector-backward-page)))

(define-key evil-normal-state-map (kbd "<f7>") 'handle-f7)
(define-key evil-normal-state-map (kbd "C-]") 'handle-goto-def)
(define-key evil-normal-state-map (kbd "C-h") 'handle-navigate-back)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom theme and font
;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (deeper-blue)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Droid Sans Mono" :foundry "unknown" :slant normal :weight normal :height 113 :width normal)))))
