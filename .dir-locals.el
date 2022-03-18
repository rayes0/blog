((org-mode . ((eval . (defun blog/org-filter-out-fignum (data _ _)
                        (replace-regexp-in-string "<span class=.*figure-number.*Figure .*: </span>"
                                                  ""
                                                  data)))
              (eval . (setq-local org-export-filter-link-functions '(blog/org-filter-out-fignum)))
              ;; (eval . (defun blog/hugo-return-directory-from-static (path)
              ;;           (if (cl-search "~/sites/personal-site/static/" path)
              ;;               (replace-regexp-in-string (regexp-quote "~/sites/personal-site/static")
              ;;                                         ""
              ;;                                         path)
              ;;               (progn (message "file outside static dir (prob wrong path)")
              ;;                      path))))
              ;; (org-link-file-path-type . #'blog/hugo-return-directory-from-static)
              ;; (org-link-file-path-type . 'relative)
              )))