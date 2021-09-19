(menu-bar-mode -1)
(tool-bar-mode -1)

(eval-when-compile (require 'use-package))

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
