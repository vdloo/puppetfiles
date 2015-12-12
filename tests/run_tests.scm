#lang racket/base

(require rackunit)
(require rackunit/text-ui)
(require racket/string)
(require racket/include)

(include "lib/test_procedures.scm")

(include "integration/dotfiles.scm")

(run-tests dotfile_tests)
