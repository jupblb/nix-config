(menu-bar-mode -1)

(eval-when-compile (require 'use-package))

(use-package which-key
  :config (which-key-mode))

(use-package gruvbox-theme
  :config (load-theme 'gruvbox-light-hard t))

(use-package evil
  :ensure t
  :init
    (setq evil-shift-width 2)
    (setq evil-want-keybinding nil)
  :config (evil-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :custom
    (evil-collection-company-use-tng nil)
    (evil-collection-calendar-want-org-bindings t)
    (evil-collection-setup-minibuffer t)
  :config (evil-collection-init))

(use-package doom-modeline
  :ensure t
  :init
    (setq doom-modeline-unicode-fallback t)
    (doom-modeline-mode 1))

(use-package org
  :mode (("\\.org$" . org-mode))
; :ensure org-plus-contrib
  :config
  (progn
    ;; config stuff
    ))
