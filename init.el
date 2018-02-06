;;; private/stella/init.el -*- lexical-binding: t; -*-

;; frame maximum at start
(toggle-frame-maximized)

;; line numbers relative
(nlinum-relative-mode)

;; themes
(def-package-hook! doom-themes :disable)
;; use solarized-light
(require 'solarized)
(deftheme solarized-light "The light variant of the Solarized colour theme")
(create-solarized-theme 'light 'solarized-light)
(provide-theme 'solarized-light)

;; fcitx
(def-package! fcitx
  :config
  ;; Make sure the following comes before `(fcitx-aggressive-setup)'
  ;; (setq fcitx-active-evil-states '(insert emacs hybrid)) ;; if you use hybrid mode
  (fcitx-aggressive-setup)
  ;; (fcitx-prefix-keys-add "M-m") ;; M-m is common in Spacemacs
  (setq fcitx-use-dbus t) ;; uncomment if you're using Linux
  )
