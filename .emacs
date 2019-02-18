(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(require 'fill-column-indicator)
(setq-default fill-column 80)

(require 'ido)
(ido-mode t)

(require 'xcscope)
;; setq cscope-do-not-update-database t)
(define-key global-map [(control f3)] 'cscope-set-initial-directory)
(define-key global-map [(control f4)] 'cscope-find-this-file)
(define-key global-map [(control f5)] 'cscope-find-this-symbol)
(define-key global-map [(control f6)] 'cscope-find-global-definition)
(define-key global-map [(control f7)] 'cscope-find-this-text-string)
(define-key global-map [(control f8)] 'cscope-pop-mark)
(define-key global-map [(control f9)] 'cscope-find-functions-calling-this-function)
(define-key global-map [(control f10)] 'cscope-find-called-functions)
(define-key global-map [(control f11)] 'cscope-display-buffer)

(set-frame-font "-*-DejaVu Sans Mono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-*-Menlo-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")


(column-number-mode t)
(display-time-mode t)
(show-paren-mode t)
(which-function-mode t)

;; Setting relevant only if running in a windowing system 
(if (display-graphic-p)
    (ns-toggle-toolbar)
  )

;; Needed to locate cscope executable installed with brew
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; Enable Hide-Show minor mode for C and Python
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'dts-mode-hook 'hs-minor-mode)

;; Open files ending in “.ino” in C++ mode
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode))

(add-to-list 'auto-mode-alist '("defconfig\\'" . conf-mode))

;; Look for a regex at the beginning of file
(add-to-list 'magic-mode-alist '("# Kconfig.+" . conf-mode))


;; Define keyboard shortcut for running compilation
(define-key global-map "\C-xc" 'compile)

;; Automatically revert buffer
(global-auto-revert-mode 1)

;; Use a combination of built-in indent-to-column and untabify insteaf
;; (defun fill-to-end (char)
;;   (interactive "cFill Character:")
;;   (save-excursion
;;     (end-of-line)
;;     (while (< (current-column) 80)
;;       (insert-char char))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
    (dts-mode fill-column-indicator company-irony company irony use-package cmake-mode yaml-mode xcscope solarized-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; == irony-mode ==
(use-package irony
  :ensure t
  :defer t
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  :config
  ;; replace the `completion-at-point' and `complete-symbol' bindings in
  ;; irony-mode's buffers by irony-mode's function
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  )

;; == company-mode ==
(use-package company
  :ensure t
  :defer t
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (use-package company-irony :ensure t :defer t)
  (setq company-idle-delay              nil
	company-minimum-prefix-length   2
	company-show-numbers            t
	company-tooltip-limit           20
	company-dabbrev-downcase        nil
	company-backends                '((company-irony company-gtags))
	)
  :bind ("C-;" . company-complete-common)
  )

;; Fix Doxy comment (starting with /**) color to display in light gray
;; instead of blue;
;; Used
;;  M-x list-faces-display
;; and
;;  M-x customize-face (place cursor on code section)
;; M-x customize-themes

;; (set-face-foreground 'font-lock-doc-face "#93a1a1")
