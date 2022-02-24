;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((org-mode . ((eval . (defun my/org-filter-out-fignum (data _ _)
                        (replace-regexp-in-string "<span class=.*figure-number.*Figure .*: </span>" "" data)))
              (eval . (setq-local org-export-filter-link-functions '(my/org-filter-out-fignum))))))