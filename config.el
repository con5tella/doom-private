;;; private/stella/config.el -*- lexical-binding: t; -*-

(load! +bindings)

;;
;; Plugins
;;

(def-package! emacs-snippets :after yasnippet)

(when (featurep 'evil)
  (load! +evil-commands)

  ;; Makes ; and , the universal repeat-keys in evil-mode
  (defmacro do-repeat! (command next-func prev-func)
    "Repeat motions with ;/,"
    (let ((fn-sym (intern (format "+evil*repeat-%s" command))))
      `(progn
         (defun ,fn-sym (&rest _)
           (define-key evil-motion-state-map (kbd ";") ',next-func)
           (define-key evil-motion-state-map (kbd ",") ',prev-func))
         (advice-add #',command :before #',fn-sym))))

  ;; n/N
  (do-repeat! evil-ex-search-next evil-ex-search-next evil-ex-search-previous)
  (do-repeat! evil-ex-search-previous evil-ex-search-next evil-ex-search-previous)
  (do-repeat! evil-ex-search-forward evil-ex-search-next evil-ex-search-previous)
  (do-repeat! evil-ex-search-backward evil-ex-search-next evil-ex-search-previous)

  ;; f/F/t/T/s/S
  (after! evil-snipe
    (setq evil-snipe-repeat-keys nil
          evil-snipe-override-evil-repeat-keys nil) ; causes problems with remapped ;

    (do-repeat! evil-snipe-f evil-snipe-repeat evil-snipe-repeat-reverse)
    (do-repeat! evil-snipe-F evil-snipe-repeat evil-snipe-repeat-reverse)
    (do-repeat! evil-snipe-t evil-snipe-repeat evil-snipe-repeat-reverse)
    (do-repeat! evil-snipe-T evil-snipe-repeat evil-snipe-repeat-reverse)
    (do-repeat! evil-snipe-s evil-snipe-repeat evil-snipe-repeat-reverse)
    (do-repeat! evil-snipe-S evil-snipe-repeat evil-snipe-repeat-reverse)
    (do-repeat! evil-snipe-x evil-snipe-repeat evil-snipe-repeat-reverse)
    (do-repeat! evil-snipe-X evil-snipe-repeat evil-snipe-repeat-reverse))

  ;; */#
  (after! evil-visualstar
    (do-repeat! evil-visualstar/begin-search-forward
                evil-ex-search-next evil-ex-search-previous)
    (do-repeat! evil-visualstar/begin-search-backward
                evil-ex-search-previous evil-ex-search-next))

  (after! evil-easymotion
    (let ((prefix (concat doom-leader-key " /")))
      ;; NOTE `evilem-default-keybinds' unsets all other keys on the prefix (in
      ;; motion state)
      (evilem-default-keybindings prefix)
      (evilem-define (kbd (concat prefix " n")) #'evil-ex-search-next)
      (evilem-define (kbd (concat prefix " N")) #'evil-ex-search-previous)
      (evilem-define (kbd (concat prefix " s")) #'evil-snipe-repeat
                     :pre-hook (save-excursion (call-interactively #'evil-snipe-s))
                     :bind ((evil-snipe-scope 'buffer)
                            (evil-snipe-enable-highlight)
                            (evil-snipe-enable-incremental-highlight)))
      (evilem-define (kbd (concat prefix " S")) #'evil-snipe-repeat-reverse
                     :pre-hook (save-excursion (call-interactively #'evil-snipe-s))
                     :bind ((evil-snipe-scope 'buffer)
                            (evil-snipe-enable-highlight)
                            (evil-snipe-enable-incremental-highlight))))))

;(setq doom-font (font-spec :family "Source Code Pro" :size 16))

;; config -*- stella version

;; set Chinese fonts not using chinese layer, same to chinese-fonts-setup, cnfonts
(set-frame-font "Source Code Pro")
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
                    charset (font-spec :family "Source Han Sans CN" :size 20)))

;; set face-attribute font, disabling in default theme
(set-face-attribute 'font-lock-function-name-face nil :weight 'bold)
(set-face-attribute 'font-lock-type-face nil :weight 'semi-bold :slant 'italic)
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
;; (set-face-attribute 'font-lock-string-face nil :foreground '"forest green")

;; ace-pinyin
(def-package! ace-pinyin
  :config
  ;; (setq ace-pinyin-use-avy nil) ;; uncomment if you want to use `ace-jump-mode
  (ace-pinyin-global-mode +1)
  ;; (setq ace-pinyin-simplified-chinese-only-p nil)
  )

;; bing-dict
(def-package! bing-dict
  :config
  (setq bing-dict-show-thesaurus 'both)
  ;; (setq bing-dict-pronunciation-style 'uk)
  )

;; pangu-spacing
(def-package! pangu-spacing
  :config
  (global-pangu-spacing-mode 1)
  ;; (setq pangu-spacing-real-insert-separtor t)
  )

(add-hook! (org-mode markdown-mode)
  (set (make-local-variable 'pangu-spacing-real-insert-separtor) t)
  )

(add-hook! LaTeX-mode
  (setq truncate-lines nil)  ;; truncate lines ignore words
  )

;; -*- key bindings

(map!

 :n ";" #'comment-line
 :v ";" #'comment-or-uncomment-region
 :n "C-j" #'doom/newline-and-indent
 :n "M-g" #'magit-status
 :n "f" #'evil-avy-goto-char

 (:leader

   (:desc "Previous Buffer" :nv "TAB" #'doom/previous-buffer)

   (:desc "buffer" :prefix "b"
     :desc "Switch buffer" :n "b" #'switch-to-buffer)

   ;; (:desc "git" :prefix "g"
   ;;   :desc "Git status" :n "s" #'magit-status)

   (:desc "help" :prefix "h"
     :n "h" help-map
     :desc "Bing Dict" :nv "b" #'bing-dict-brief)

   (:desc "window" :prefix "w"
     :desc "Max Window" :n "m" #'delete-other-windows)

   )

 (:after org
   (:map org-mode-map
     :nv "C-e" #'evil-end-of-visual-line
     :nv "j" #'evil-next-visual-line
     :nv "k" #'evil-previous-visual-line))

 )
