;; autoload

;; [[file:../../../../Projects/home/emacs.org::*autoload][autoload:1]]
;;;###autoload
(defun my-ui ()
  (interactive)
  (message "UI"))
;; autoload:1 ends here

;; Line highlight

;; [[file:../../../../Projects/home/emacs.org::*Line highlight][Line highlight:1]]
(global-hl-line-mode 1)
(set-face-attribute 'hl-line nil 
                    :box t
                    :inverse-video nil
                    :weight 'ultra-bold)
;; Line highlight:1 ends here



;; These fonts suit me currently.

;; [[file:../../../../Projects/home/emacs.org::*Font][Font:2]]
(when
    (eq window-system 'x)

    ;; (set-face-attribute 'default nil        :font "Noto Mono" :height 110)
    ;; (set-face-attribute 'fixed-pitch nil    :font "Noto Mono" :height 110)
    ;; (set-face-attribute 'variable-pitch nil :font "Cantarell" :height 160 :weight 'regular)

  (use-package unicode-fonts
    :delight
    :config
    (unicode-fonts-setup)
      ; (set-fontset-font "fontset-default" nil "DejaVu Sans Mono" nil 'append)
      ; (set-face-attribute 'default nil :family "DejaVu")
      ; (set-fontset-font "fontset-startup" nil "DejaVu Sans Mono" nil 'append)
    ))

(when
    (eq window-system 'w32)

    ;; (set-face-attribute 'default nil        :font "Noto Mono" :height 110)
    ;; (set-face-attribute 'fixed-pitch nil    :font "Noto Mono" :height 110)
    ;; (set-face-attribute 'variable-pitch nil :font "-outline-Noto Serif Thin-thin-normal-normal-serif-*-*-*-*-p-*-iso10646-1" :height 160)

  (use-package unicode-fonts
    :delight
    :config
    (unicode-fonts-setup)
      ;(set-fontset-font "fontset-default" nil "-outline-Consolas-normal-r-normal-normal-14-97-96-96-c-*-iso8859-1" nil 'append)
      ;(set-face-attribute 'default nil :family "Consolas")
      ;(set-fontset-font "fontset-startup" nil "-outline-Consolas-normal-r-normal-normal-14-97-96-96-c-*-iso8859-1" nil 'append)
    ))
;; Font:2 ends here

;; Fonts

;; [[file:../../../../Projects/home/emacs.org::*Fonts][Fonts:1]]
;(set-frame-font "Fantasque Sans Mono-14" nil t)
;(set-frame-font "Source Code Pro-14" nil t)
  (defvar my/fixed-pitch-font "Noto Mono")
  (defvar my/fixed-pitch-height 110)
  (defvar my/variable-pitch "Cantarell")
  (defvar my/variable-pitch-height 160)
;; Fonts:1 ends here

;; Disable all themes

;; [[file:../../../../Projects/home/emacs.org::*Disable all themes][Disable all themes:1]]
(defun sb/disable-all-themes ()
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))
;; Disable all themes:1 ends here

;; Load theme

;; [[file:../../../../Projects/home/emacs.org::*Load theme][Load theme:1]]
(defun sb/load-theme (theme)
  "Enhance `load-theme' by first disabling enabled themes."
  (sb/disable-all-themes)
  (load-theme theme t)
  (sml/apply-theme 'light-powerline))
;; Load theme:1 ends here

;; A theme switching hydra

;; [[file:../../../../Projects/home/emacs.org::*A theme switching hydra][A theme switching hydra:1]]
(setq sb/hydra-selectors
      "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")

(defun sb/sort-themes (themes)
  (sort themes
        (lambda (a b)
          (string<
           (symbol-name a)
           (symbol-name b)))))

(defun sb/hydra-load-theme-heads (themes)
  (mapcar* (lambda (a b)
             (list (char-to-string a)
                   `(sb/load-theme ',b)
                   (symbol-name b)))
           sb/hydra-selectors themes))

(defun populate-theme-hydra ()
  (interactive)
  (eval `(defhydra sb/hydra-select-themes
           (:hint nil :color pink)
           "Select Theme"
           ,@(sb/hydra-load-theme-heads
              (sb/sort-themes
               (custom-available-themes)))
           ("DEL" (sb/disable-all-themes))
           ("RET" nil "done" :color blue))))

(with-eval-after-load 'major-mode-hydra
    (message "Attaching hydra to leader - theme change")
    (pretty-hydra-define+ my/hydra-leader ()
      ("Shortcuts"
       (("t" (progn 
               (populate-theme-hydra)
               (sb/hydra-select-themes/body)
               (hydra-push '(my/hydra-leader/body))) 
         "scale text")))))
;; A theme switching hydra:1 ends here

;; Smart mode line powerline theme

;; [[file:../../../../Projects/home/emacs.org::*Smart mode line powerline theme][Smart mode line powerline theme:1]]
(use-package smart-mode-line-powerline-theme)
;; Smart mode line powerline theme:1 ends here

;; Apply a theme

;; [[file:../../../../Projects/home/emacs.org::*Apply a theme][Apply a theme:1]]
(use-package doom-themes
  :after smart-mode-line
  :delight
  :config
                                        ;(load-theme 'doom-snazzy t
                                        ;(load-theme 'doom-manegarm t
                                        ;(load-theme 'whiteboard t)
                                        ;(load-theme 'doom-sourcerer t)
  (sb/load-theme 'doom-one-light))
;; Apply a theme:1 ends here

;; smart modeline

;; [[file:../../../../Projects/home/emacs.org::*smart modeline][smart modeline:1]]
(use-package smart-mode-line
  :after smart-mode-line-powerline-theme

  :init
  (setq sml/no-confirm-load-theme t)
  (setq sml/vc-mode-show-backend t)

  :config
  (sml/setup)
  ;(sml/apply-theme 'light-powerline)
  )
;; smart modeline:1 ends here

;; eldoc-mode shows documentation in the minibuffer when writing code
;; http://www.emacswiki.org/emacs/ElDoc

;; [[file:../../../../Projects/home/emacs.org::*eldoc-mode shows documentation in the minibuffer when writing code][eldoc-mode shows documentation in the minibuffer when writing code:1]]
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
;; eldoc-mode shows documentation in the minibuffer when writing code:1 ends here

;; Nyan-mode
;; Just a little bit of fun, but way cooler than a scrollbar :)

;; [[file:../../../../Projects/home/emacs.org::*Nyan-mode][Nyan-mode:1]]
(use-package nyan-mode
  :delight
  :custom (nyan-wavy-trail 't)
  :config 
  (nyan-mode)
  (nyan-start-animation))
;; Nyan-mode:1 ends here

;; Free as much screen real-estate as possible
;; It's fine, the tooltip can stay, it'll display in the echo area.

;; [[file:../../../../Projects/home/emacs.org::*Free as much screen real-estate as possible][Free as much screen real-estate as possible:1]]
(tooltip-mode t)
;; Free as much screen real-estate as possible:1 ends here


;; I don't need scrollbars, I have nyan mode

;; [[file:../../../../Projects/home/emacs.org::*Free as much screen real-estate as possible][Free as much screen real-estate as possible:2]]
(scroll-bar-mode -1)
;; Free as much screen real-estate as possible:2 ends here


;; Bye bye pretty button bar, I prefer M-`

;; [[file:../../../../Projects/home/emacs.org::*Free as much screen real-estate as possible][Free as much screen real-estate as possible:3]]
(tool-bar-mode -1)
;; Free as much screen real-estate as possible:3 ends here


;; As above

;; [[file:../../../../Projects/home/emacs.org::*Free as much screen real-estate as possible][Free as much screen real-estate as possible:4]]
(menu-bar-mode 0) ; so long file -> menu
;; Free as much screen real-estate as possible:4 ends here

;; Bell
;; I'm not a big fan of noise, but I do like the visible bell

;; [[file:../../../../Projects/home/emacs.org::*Bell][Bell:1]]
(setq visible-bell t)
(setq ring-bell-function nil) ; I wonder what other people are doing with this setting?
;; Bell:1 ends here

;; Cursor blinking
;; I find a blinking cursor can be distracting

;; [[file:../../../../Projects/home/emacs.org::*Cursor blinking][Cursor blinking:1]]
(blink-cursor-mode 0)
;; Cursor blinking:1 ends here

;; Dialog boxes
;; I don't think dialog boxes are my style.

;; [[file:../../../../Projects/home/emacs.org::*Dialog boxes][Dialog boxes:1]]
(setq use-dialog-box nil)
;; Dialog boxes:1 ends here

;; Frame transparency

;; [[file:../../../../Projects/home/emacs.org::*Frame transparency][Frame transparency:1]]
(set-frame-parameter (selected-frame) 'alpha '(100 . 100))
(add-to-list 'default-frame-alist '(alpha . (100 . 100)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; Frame transparency:1 ends here

;; Icons

;; [[file:../../../../Projects/home/emacs.org::*Icons][Icons:1]]
(use-package all-the-icons :delight)
;; Icons:1 ends here

;; Line numbers
;; I prefer line numbers in most modes for pair programming etc, but have found enabling them on a per-mode basis rather than globally works best.

;; [[file:../../../../Projects/home/emacs.org::*Line numbers][Line numbers:1]]
(global-display-line-numbers-mode 0)
(dolist (mode '(elisp-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))
;; Line numbers:1 ends here

;; Parenthesis colour matching

;; [[file:../../../../Projects/home/emacs.org::*Parenthesis colour matching][Parenthesis colour matching:1]]
(use-package rainbow-delimiters
  :delight
  :hook (prog-mode . rainbow-delimiters-mode))
;; Parenthesis colour matching:1 ends here

;; Highlight s-exp
;; https://github.com/daimrod/highlight-sexp

;; [[file:../../../../Projects/home/emacs.org::*Highlight s-exp][Highlight s-exp:1]]
;(use-package highlight-sexp
;  :delight
;  :hook (prog-mode . highlight-sexp-mode)
;  :custom ((hl-sexp-face hl-line)))
;; Highlight s-exp:1 ends here

;; Scrolling
;; One line at a time.

;; [[file:../../../../Projects/home/emacs.org::*Scrolling][Scrolling:1]]
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
;; Scrolling:1 ends here


;; Don't accelerate scrolling

;; [[file:../../../../Projects/home/emacs.org::*Scrolling][Scrolling:2]]
(setq mouse-wheel-progressive-speed nil)
;; Scrolling:2 ends here


;; Scroll window under mouse

;; [[file:../../../../Projects/home/emacs.org::*Scrolling][Scrolling:3]]
(setq mouse-wheel-follow-mouse 't)
;; Scrolling:3 ends here


;; Keyboard scroll one line at a time

;; [[file:../../../../Projects/home/emacs.org::*Scrolling][Scrolling:4]]
(setq scroll-step 1)
;; Scrolling:4 ends here

;; yes/no => y/n
;; Kiss, right?

;; [[file:../../../../Projects/home/emacs.org::*yes/no => y/n][yes/no => y/n:1]]
(fset 'yes-or-no-p 'y-or-n-p)
;; yes/no => y/n:1 ends here

;; provide

;; [[file:../../../../Projects/home/emacs.org::*provide][provide:1]]
(provide 'my-ui)
;; provide:1 ends here
