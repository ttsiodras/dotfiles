; Currently (2017/Q1) there's quite a mess with emacs and org mode versions.
; As soon as I tried to use ox-reveal, nothing worked properly - so this is
; the only way for a proper setup:
;
; - Download and compile latest Emacs from scratch (25.1.1 as of 2017/Q1)
;   via ./configure --prefix=/usr/local/packages ; make -j4 ; make install
; - REMOVE the two org folders (find . -name org) under the install folder
; - Install emacs via graft from /usr/local/packages
; - Downloaded the org-mode tarball, and uncompress it under .emacs.d/org-9.0.5
; - sudo apt-get install texinfo (for makeinfo)
; - cd .emacs,d/org-9.0.5 && make
;
; Use this .emacs file that you are reading :-)
;
; - After that, launch emacs and "Esc-x"/list-packages
; - navigate to evil
; - Hit 'i' to mark it, 'x' to install
; - same for:
;      evil-leader
;      powerline
;      helm
;      powerline
;      linum-relative
;      ensime
;      ox-reveal
;      htmlize (syntax highlight source blocks)
;
; The installation of these packages may also be done via:
;
;      package-install<RET>evil<RET> (etc)
;
; That's it!
; Try exporting your org files to reveal.js with C-c C-e R R ...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Backup files settings - from:
;; http://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;;;;;;;;;;;;;;;;;;;;;;
;; Setup package lists
;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives
         '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
         '("gnu" . "http://elpa.gnu.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;;;;;;;;;;;
; evil mode
;;;;;;;;;;;

; Stop evil from defining TAB key behavior; we need it for org-mode
(setq evil-want-C-i-jump nil)
(require 'evil)
(require 'evil-leader)
(global-evil-leader-mode)

;; Start in evil mode
(evil-mode 1)

;; Close window with C-F12
(define-key evil-normal-state-map (kbd "C-<f12>") 'evil-delete-buffer)

;; spawn shell with F2 in current folder
;; ;; deprecated, too strong:(global-set-key [f2] 'shell)
(define-key evil-normal-state-map (kbd "<f2>") 'shell)

;; TAB and S-TAB cycle between buffers
;; ;; deprecated, org-mode needs this to expand sections
;;(define-key evil-normal-state-map (kbd "<tab>") 'evil-next-buffer)
;;(define-key evil-normal-state-map (kbd "<backtab>") 'evil-prev-buffer)

;;;;;;;;;;
; org mode
;;;;;;;;;;

;; necessary in the current mess with org versions
;; (you need to remove your Emacs's org folders (see top of this file)
(add-to-list 'load-path "~/.emacs.d/org-9.0.5/lisp/")
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode source code blocks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(org-babel-do-load-languages
  'org-babel-load-languages
  '((shell . t) (perl . t) (python . t)))
;;(setq org-confirm-babel-evaluate nil)

;;;;;;;;;;;;;;;;;;;
;; Org-agenda files
;;;;;;;;;;;;;;;;;;;
(setq org-agenda-files '("~/Github/TODO/Home.org" "~/Github/TODO/TODO.org"))

;;;;;;;;;;
; ensime
;;;;;;;;;;

;; If necessary, add JDK_HOME or JAVA_HOME to the environment
;; (setenv "JDK_HOME" "/path/to/jdk")

;; If necessary, make sure "sbt" and "scala" are in the PATH environment
;; (setenv "PATH" (concat "/path/to/sbt/bin:" (getenv "PATH")))
;; (setenv "PATH" (concat "/path/to/scala/bin:" (getenv "PATH")))

;; You can also customize `ensime-inf-get-project-root' and `ensime-inf-get-repl-cmd-line'
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
;; (add-hook 'ensime-source-buffer-saved-hook 'ensime-show-all-errors-and-warnings)

;; Key mappings for scala (maybe others, too?)
;;
;; F7 typechecks all
;; C-] goes to definition
;; \t shows the type under the symbol
;; C-h does back in the window opened via \t
;;
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

;; Setup Scala type inspection via leader-t
(evil-leader/set-key "t" 'ensime-inspect-type-at-point)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom theme and font
;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (deeper-blue)))
 '(custom-safe-themes
   (quote
    ("582e9531b4f788cb66441b58038759f140c3670a403b9c124fa3ea7b7ab0d967" default)))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (htmlize ox-reveal powerline linum-relative helm evil-leader ensime))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Droid Sans Mono" :foundry "unknown" :slant normal :weight normal :height 113 :width normal))))
 '(org-hide ((t (:foreground "black")))))

;;;;;;;;;;;;;;;;;
;; line number
;;;;;;;;;;;;;;;;
(global-linum-mode t)
;;
;; DEPRECATED - don't auto-enable linum, because we don't want it in
;; org-mode, or shell or...
;; Instead, depend on linum-off.el (in here) to selectively toggle
;; numbers (and relative numbers) on or off, based on file type.
;;
;;(linum-mode)
;;(linum-relative-global-mode)
;;
(add-to-list 'load-path "~/.emacs.d/linum-off/")
(require 'linum-off)

;;;;;;;;;;;;;;;;;
;; powerline
;;;;;;;;;;;;;;;;
(require 'powerline)

;;;;;;;;;
;; helm
;;;;;;;;;
(require 'helm-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ignore case during filename completion in C-x C-f
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq read-file-name-completion-ignore-case t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Create nifty presentations from org-mode files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ox-reveal)

;;;;;;;;
;; F#
;;;;;;;;
;(add-to-list 'load-path "~/.emacs.d/fsharp-mode/")
;(autoload 'fsharp-mode "fsharp-mode"     "Major mode for editing F# code." t)

