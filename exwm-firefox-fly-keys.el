;;; exwm-firefox-fly-keys.el --- Firefox hotkeys to functions -*- lexical-binding: nil -*-

;; Author: Stefan Huchler
;; URL: https://github.com/spiderbit/exwm-firefox-fly-keys
;; Version: 0.1
;; Package-Requires: ((emacs "24.4") (exwm "0.16") (xah-fly-keys "20190223.716") (exwm-firefox-core "1.0"))
;; Keywords: extensions

;; exwm-firefox-fly-keys.el is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; exwm-firefox-fly-keys.el is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package implements exwm-firefox-core to allow for modal editing in
;; firefox like in xah-fly-keys
;;
;; To get link-hints you have to define a new key like below and download a
;; link-hint addon to firefox.

;;; Code:

(require 'exwm)
(require 'exwm-firefox-core)

(defvar exwm-firefox-class-name '("Firefox" "Nightly" "Iceweasel" "Icecat")
  "The class name used for detecting if a firefox buffer is selected.")

(defvar exwm-firefox-fly-keys-mode-map (make-sparse-keymap))
(defvar exwm-firefox-fly-e-keymap (make-sparse-keymap))

;; (defvar exwm-firefox-evil-insert-on-new-tab t
;;   "If non-nil, auto enter insert mode after opening new tab.")

;;; State transitions
(defun exwm-firefox-fly-keys-normal ()
  "Pass every key directly to Emacs."
  (interactive)
  (setq-local exwm-input-line-mode-passthrough t)
  (xah-fly-command-mode-activate))

(defun exwm-firefox-fly-keys-insert ()
  "Pass every key to firefox."
  (interactive)
  (setq-local exwm-input-line-mode-passthrough nil)
  (xah-fly-insert-mode-activate))

;;; Keys
(set-keymap-parent exwm-firefox-fly-keys-mode-map xah-fly-key-map)
(set-keymap-parent exwm-firefox-fly-e-keymap xah-fly-e-keymap)

(define-key exwm-firefox-fly-keys-mode-map (kbd "<menu> e") exwm-firefox-fly-e-keymap)
(define-key exwm-firefox-fly-e-keymap (kbd "e") 'exwm-edit--compose)
;; (define-key xah-fly-key-map [remap previous-line] 'exwm-firefox-core-up)
;; (define-key exwm-firefox-fly-keys-mode-map [remap next-line] 'exwm-firefox-core-down)
;; (define-key xah-fly-key-map [remap backward-char] 'exwm-firefox-core-left)
;; (define-key xah-fly-key-map [remap forward-char] 'exwm-firefox-core-right)
(define-key exwm-firefox-fly-keys-mode-map (kbd "<home>") 'exwm-firefox-fly-keys-normal)
(define-key exwm-firefox-fly-keys-mode-map (kbd "u") 'exwm-firefox-fly-keys-insert)
;; (define-key exwm-firefox-fly-keys-mode-map (kbd "<SPC>") 'exwm-firefox-fly-keys-insert)
;; (define-key exwm-firefox-fly-keys-mode-map (kbd "<SPC>") nil)

    ;;;; Normal
;; Basic movements
(define-key exwm-firefox-fly-keys-mode-map (kbd "t") 'exwm-firefox-core-down)
(define-key exwm-firefox-fly-keys-mode-map (kbd "c") 'exwm-firefox-core-up)
;; (define-key exwm-firefox-fly-keys-mode-map (kbd "h") 'exwm-firefox-core-left)
;; (define-key exwm-firefox-fly-keys-mode-map (kbd "n") 'exwm-firefox-core-right)

;; Search
(define-key exwm-firefox-fly-keys-mode-map (kbd "<tab>") 'exwm-firefox-core-focus-search-bar)

    ;;;; Transitions
;; Bind normal
;; (define-key xah-fly-key-map [remap xah-fly-command-mode-activate] 'xah-fly-command-mode-activate)
;; (define-key exwm-firefox-evil-mode-map [remap evil-normal-state] 'exwm-firefox-evil-normal)
;; (define-key exwm-firefox-evil-mode-map [remap evil-force-normal-state] 'exwm-firefox-evil-normal)
;; Bind insert
;; (define-key xah-fly-key-map [remap xah-fly-insert-mode-activate] 'exwm-firefox-fly-keys-insert)
;; (define-key exwm-firefox-evil-mode-map [remap evil-insert] 'exwm-firefox-evil-insert)
;; (define-key exwm-firefox-evil-mode-map [remap evil-substitute] 'exwm-firefox-evil-insert)
;; (define-key exwm-firefox-evil-mode-map [remap evil-append] 'exwm-firefox-evil-insert)

;; Send enter to firefox
(define-key exwm-firefox-fly-keys-mode-map (kbd "<return>")
  '(lambda () (interactive) (exwm-input--fake-key 'return)))
(define-key exwm-firefox-fly-keys-mode-map (kbd "RET")
  '(lambda () (interactive) (exwm-input--fake-key 'return)))

;; Move by half page
(define-key exwm-firefox-fly-keys-mode-map (kbd "d") 'exwm-firefox-core-half-page-up)
(define-key exwm-firefox-fly-keys-mode-map (kbd "s") 'exwm-firefox-core-half-page-down)

;; ;; Move to top/bot
;; (evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "g g") 'exwm-firefox-core-top)
;; (evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "G") 'exwm-firefox-core-bottom)

;; Reload page
(define-key exwm-firefox-fly-keys-mode-map (kbd "<C-r>") 'exwm-firefox-core-reload)
(define-key exwm-firefox-fly-keys-mode-map (kbd "<C-R>") 'exwm-firefox-core-reload-override-cache)
;; History
(define-key exwm-firefox-fly-keys-mode-map (kbd "n") 'exwm-firefox-core-history-forward)
(define-key exwm-firefox-fly-keys-mode-map (kbd "h") 'exwm-firefox-core-history-back)

;; Find
(define-key exwm-firefox-fly-keys-mode-map (kbd "<menu> g") 'exwm-firefox-core-quick-find)
(define-key exwm-firefox-fly-keys-mode-map (kbd "C-s") 'exwm-firefox-core-find-next)
(define-key exwm-firefox-fly-keys-mode-map (kbd "C-r") 'exwm-firefox-core-find-previous)

;; Editing
(define-key exwm-firefox-fly-keys-mode-map (kbd "r") 'exwm-firefox-core-forward-word)
(define-key exwm-firefox-fly-keys-mode-map (kbd "g") 'exwm-firefox-core-back-word)
(define-key exwm-firefox-fly-keys-mode-map (kbd "k") 'exwm-firefox-core-paste)
(define-key exwm-firefox-fly-keys-mode-map (kbd "j") 'exwm-firefox-core-copy)
(define-key exwm-firefox-fly-keys-mode-map (kbd "q") 'exwm-firefox-core-cut)
(define-key exwm-firefox-fly-keys-mode-map (kbd "p") (lambda () (interactive) (exwm-firefox-core-forward-word-select)(exwm-firefox-core-delete)))
(define-key exwm-firefox-fly-keys-mode-map (kbd ".") (lambda () (interactive) (exwm-firefox-core-back-word-select)(exwm-firefox-core-delete)))
(define-key exwm-firefox-fly-keys-mode-map (kbd "8") (lambda () (interactive) (exwm-firefox-core-back-word)(exwm-firefox-core-forward-word-select)))

(define-key exwm-firefox-fly-keys-mode-map (kbd "f") 'exwm-firefox-core-undo)
;; (evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "C-r") 'exwm-firefox-core-redo)
;; (define-key exwm-firefox-fly-keys-mode-map (kbd "e") 'exwm-firefox-core-delete)

;; Select all and stop user from entering visual and insert state
(define-key exwm-firefox-fly-keys-mode-map (kbd "<menu> a") 'exwm-firefox-core-select-all)
(define-key exwm-firefox-fly-keys-mode-map (kbd "C-a") 'exwm-firefox-core-select-all)

;; Pass through esc when in normal mode
(define-key exwm-firefox-fly-keys-mode-map (kbd "<escape>") 'exwm-firefox-core-cancel)

;; hint mode / copy url (needs firefox addon)
;; (define-key exwm-firefox-fly-keys-mode-map (kbd "y") '(lambda () (interactive) (exwm-input--fake-key 'u)(exwm-firefox-fly-keys-insert)))
(define-key exwm-firefox-fly-keys-mode-map (kbd "<menu> j") '(lambda () (interactive) (dotimes (i 2) (exwm-input--fake-key 'y))))

;; ;; Tab movement
;; (evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "J") 'exwm-firefox-core-tab-next)
;; (evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "K") 'exwm-firefox-core-tab-previous)
;; (evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "x") 'exwm-firefox-core-tab-close)
;; (evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "t") 'exwm-firefox-core-tab-new)
;; (evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "0") 'exwm-firefox-core-tab-first)
;; (evil-define-key 'normal exwm-firefox-evil-mode-map (kbd "$") 'exwm-firefox-core-tab-last)

;;; Mode
;;;###autoload
(define-minor-mode exwm-firefox-fly-keys-mode nil nil " exwm-firefox" exwm-firefox-fly-keys-mode-map
  (if exwm-firefox-fly-keys-mode
      (progn
  	(exwm-firefox-fly-keys-normal)
	;; Auto enter insert mode on some actions
  	;; (if exwm-firefox-evil-insert-on-new-tab
  	;;     (advice-add #'exwm-firefox-core-tab-new :after #'exwm-firefox-evil-insert))

  	;; (advice-add #'exwm-firefox-core-focus-search-bar :after #'exwm-firefox-fly-keys-insert)
  	;; (advice-add #'exwm-firefox-core-find :after #'exwm-firefox-fly-keys-insert)
  	;; (advice-add #'exwm-firefox-core-quick-find :after #'exwm-firefox-fly-keys-insert)
	)

    ;; Clean up advice
    ;; (advice-remove #'exwm-firefox-core-tab-new #'exwm-firefox-fly-keys-insert)
    ;; (advice-remove #'exwm-firefox-core-focus-search-bar #'exwm-firefox-fly-keys-insert)
    ;; (advice-remove #'exwm-firefox-core-find #'exwm-firefox-fly-keys-insert)
    ;; (advice-remove #'exwm-firefox-core-quick-find #'exwm-firefox-fly-keys-insert))
    ))

;;;###autoload
(defun exwm-firefox-fly-keys-activate-if-firefox ()
  "Activates exwm-firefox mode when buffer is firefox.
Firefox variant can be assigned in 'exwm-firefox-fly-keys-firefox-name`"
  (interactive)
  (if (member exwm-class-name exwm-firefox-class-name)
      (exwm-firefox-fly-keys-mode 1)))

(provide 'exwm-firefox-fly-keys)

;;; exwm-firefox-fly-keys.el ends here
