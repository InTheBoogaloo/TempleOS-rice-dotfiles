;;; =========================
;;; init.el — configuración RC
;;; =========================

;;; -------------------------
;;; Package management
;;; -------------------------

(require 'package)

(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

;; Refrescar repos solo una vez
(unless package-archive-contents
  (package-refresh-contents))

;; Paquetes requeridos
(dolist (pkg '(smex ido-completing-read+ ace-window
                    almost-mono-themes pdf-tools ess))
  (unless (package-installed-p pkg)
    (package-install pkg)))

;;; -------------------------
;;; UI & comportamiento general
;;; -------------------------

(setq inhibit-startup-screen t)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(global-display-line-numbers-mode 1)
(show-paren-mode 1)

(mouse-wheel-mode -1)     ;; desactivar scroll touchpad
(setq create-lockfiles nil)

(electric-pair-mode 1)

;;; -------------------------
;;; Indentación & tabs
;;; -------------------------

(setq-default tab-width 8
              indent-tabs-mode t)

(add-hook 'c-mode-common-hook
          (lambda ()
            (setq tab-width 8
                  indent-tabs-mode t
                  c-basic-offset 8)))

;;; -------------------------
;;; Completion (ido + smex)
;;; -------------------------

(require 'ido)
(require 'ido-completing-read+)
(require 'smex)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

(smex-initialize)

(global-set-key (kbd "M-x") #'smex)
(global-set-key (kbd "C-c C-c M-x") #'execute-extended-command)

;;; -------------------------
;;; Keybindings & utilidades
;;; -------------------------

;; Quitar bindings molestos
(global-unset-key (kbd "M-c"))
(global-unset-key (kbd "M-u"))
(global-unset-key (kbd "M-l"))

;; Manejo de ventanas
(require 'ace-window)
(global-set-key (kbd "M-p") #'ace-window)

;; Duplicar línea actual
(defun rc/duplicate-line ()
  "Duplicate current line."
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") #'rc/duplicate-line)

;;; -------------------------
;;; PDF tools
;;; -------------------------

;; Apagar line numbers en PDFs
(add-hook 'pdf-view-mode-hook
          (lambda ()
            (display-line-numbers-mode 0)))

(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode) ;; detectar PDFs por contenido
  :config
  (pdf-tools-install))

;;; -------------------------
;;; Tema & fuente
;;; -------------------------

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(load-theme 'temple-os t)
;; (load-theme 'temple-dark t)

(set-frame-font
 "-PfEd-TempleOS-regular-normal-normal-*-14-*-*-*-m-0-iso10646-1"
 t t)

;;; -------------------------
;;; Custom (auto-generado)
;;; -------------------------

(custom-set-variables
 '(package-selected-packages
   '(ace-window almost-mono-themes ess
                ido-completing-read+ pdf-tools
                smex sudo-edit)))

(custom-set-faces)

;;; =========================
;;; FIN
;;; =========================
