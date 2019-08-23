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
(require 'xah-fly-keys)

(defvar exwm-firefox-class-name '("Firefox" "Nightly" "Iceweasel" "Icecat")
  "The class name used for detecting if a firefox buffer is selected.")

(defvar exwm-firefox-fly-keys-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map xah-fly-key-map)
    (define-key map (kbd "m") 'kodi-remote-music)
    (define-key map (kbd "<menu> e") exwm-firefox-fly-e-keymap)
    (define-key map (kbd "e") 'exwm-edit--compose)
    (define-key map (kbd "<home>") 'exwm-firefox-fly-keys-normal)
    (define-key map (kbd "u") 'exwm-firefox-fly-keys-insert)
    ;; Basic movements
    (define-key map (kbd "t") 'exwm-firefox-core-down)
    (define-key map (kbd "c") 'exwm-firefox-core-up)
    ;; Search
    (define-key map (kbd "<tab>") 'exwm-firefox-core-focus-search-bar)
    ;; Send enter to firefox
    (define-key map (kbd "<return>")
      '(lambda () (interactive) (exwm-input--fake-key 'return)))
    (define-key map (kbd "RET")
      '(lambda () (interactive) (exwm-input--fake-key 'return)))
    ;; Move by half page
    (define-key map (kbd "d") 'exwm-firefox-core-half-page-up)
    (define-key map (kbd "s") 'exwm-firefox-core-half-page-down)
    ;; Reload page
    (define-key map (kbd "<C-r>") 'exwm-firefox-core-reload)
    (define-key map (kbd "<C-R>") 'exwm-firefox-core-reload-override-cache)
    ;; History
    (define-key map (kbd "n") 'exwm-firefox-core-history-forward)
    (define-key map (kbd "h") 'exwm-firefox-core-history-back)
    ;; Find
    (define-key map (kbd "<menu> g") 'exwm-firefox-core-quick-find)
    (define-key map (kbd "C-s") 'exwm-firefox-core-find-next)
    (define-key map (kbd "C-r") 'exwm-firefox-core-find-previous)
    ;; Editing
    (define-key map (kbd "r") 'exwm-firefox-core-forward-word)
    (define-key map (kbd "g") 'exwm-firefox-core-back-word)
    (define-key map (kbd "k") 'exwm-firefox-core-paste)
    (define-key map (kbd "j") 'exwm-firefox-core-copy)
    (define-key map (kbd "q") 'exwm-firefox-core-cut)
    (define-key map (kbd "p")
      (lambda () (interactive)
	(exwm-firefox-core-forward-word-select)
	(exwm-firefox-core-delete)))
    (define-key map (kbd ".")
      (lambda () (interactive)
	(exwm-firefox-core-back-word-select)
	(exwm-firefox-core-delete)))
    (define-key map (kbd "8")
      (lambda () (interactive) (exwm-firefox-core-back-word)
	(exwm-firefox-core-forward-word-select)))
    (define-key map (kbd "f") 'exwm-firefox-core-undo)
    ;; Select all and stop user from entering visual and insert state
    (define-key map (kbd "<menu> a") 'exwm-firefox-core-select-all)
    (define-key map (kbd "C-a") 'exwm-firefox-core-select-all)
    ;; Pass through esc when in normal mode
    (define-key map (kbd "<escape>") 'exwm-firefox-core-cancel)
    ;; hint mode / copy url (needs firefox addon)
    (define-key map (kbd "<menu> j")
      '(lambda () (interactive) (dotimes (i 2) (exwm-input--fake-key 'y))))
    map)
  "Keymap for `exwm-firefox-fly-keys-mode'.")

(defvar exwm-firefox-fly-e-keymap
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map xah-fly-e-keymap)
    (define-key map (kbd "e") 'exwm-edit--compose)
    map))

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
