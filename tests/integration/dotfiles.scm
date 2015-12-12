(define dotfile_tests
  (test-suite
    "Tests for dotfiles puppet module"

    (test-case
      "Check if we can login with ssh and echo something"
      (check-false (eof-object? (run_command '("/bin/echo" "1"))) 
                   "output is EOF object"))

    (test-case
      "Check nonroot user exists"
      (check-false (not (regexp-match 
                          "nonroot"
                          (run_command '("grep nonroot /etc/passwd"))))))))