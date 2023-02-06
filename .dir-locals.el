((org-mode . ((org-format-latex-options . '(:foreground default
                                            :background "Transparent"
                                            :scale 0.8
                                            :html-foreground "Black"
                                            :html-background "Transparent"
                                            :html-scale 1.0
                                            :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
              (org-footnote-section . nil)
              (org-latex-create-formula-image-program . 'dvisvgm)
              (eval . (defun blog/org-filter-out-fignum (data _ _)
                        (replace-regexp-in-string "<span class=.*figure-number.*Figure .*: </span>"
                                                  ""
                                                  data)))
              (eval . (setq-local org-export-filter-link-functions '(blog/org-filter-out-fignum)))
              (eval . (defun blog/hugo-return-directory-from-static (path)
                        (cond ((cl-search "~/sites/personal-site/static/" path)
                               (replace-regexp-in-string (regexp-quote "~/sites/personal-site/static")
                                                         ""
                                                         path))
                              ((cl-search "/home/rayes/sites/personal-site/static/" path)
                               (replace-regexp-in-string (regexp-quote "/home/rayes/sites/personal-site/static")
                                                         ""
                                                         path))
                              (t (progn (message "file outside static dir (prob wrong path)")
                                        path)))))
              (eval . (setq-local org-link-file-path-type 'blog/hugo-return-directory-from-static))
              (eval . (define-minor-mode blog/org-hugo-function-advices
                          "Enable custom blog advices"))
              (blog/org-hugo-function-advices . t)
              (eval . (advice-add 'org-insert-link
                                  :around (lambda (orig &rest r)
                                            (interactive "P")
                                            (if (not blog/org-hugo-function-advices)
                                                (call-interactively orig)
                                                (let ((default-directory "/home/rayes/sites/personal-site/static/img/"))
                                                  (call-interactively orig))))))
              (eval . (defun blog/org-hugo-make-link-desc (l g)
                        (if g g
                            (when (string-match-p "^/img/.*$" l)
                              (if (yes-or-no-p "Auto link? ")
                                  (concat "file:" l)
                                  (read-string "Description: " initial-input)
                                  initial-input)))))
              (eval . (setq-local org-link-make-description-function 'blog/org-hugo-make-link-desc))
              (eval . (defun blog/org-hugo-title-with-markup (info)
                        (when (plist-get info :with-title)
                          (org-export-data-with-backend (plist-get info :title) 'md info))))
              (eval . (advice-add 'org-hugo--get-sanitized-title
                                  :override #'blog/org-hugo-title-with-markup))
              (org-babel-lilypond-gen-svg . t))))