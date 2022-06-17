;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Nicholas Von Wolff"
      user-mail-address "nvonwolff@gmail.com")

;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; Set Theme
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Projectile Search Path
(setq projectile-project-search-path '( "~/.doom.d" "~/dotfiles" ("~/projects/". 3) ) )

;; Autosave and Backups
(setq auto-save-default t
      make-backup-files t)

;; Disable exit confirmation
(setq confirm-kill-emacs nil)

;; set default encodings
(prefer-coding-system           'utf-8)
(set-default-coding-systems     'utf-8)
(set-terminal-coding-system     'utf-8)
(set-keyboard-coding-system     'utf-8)
(setq buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; Do not create lockfiles
(setq create-lockfiles nil)
