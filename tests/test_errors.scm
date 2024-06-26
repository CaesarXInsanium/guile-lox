(use-modules (glox error)
             (glox char)
             (glox utils)
             (ice-9 exceptions)
             (srfi srfi-43))
;; testing
(use-modules (srfi srfi-64))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sanity checks
(test-begin "todo")
(test-assert (exception-type? &todo-error))
(test-assert (todo-error? (make-todo-error)))
;; check that the error that we raise is a &todo
(test-error &todo-error (raise-exception &todo-error))
(test-end "todo")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lox-error
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(test-begin "lox-error")
(test-assert (exception-type? &lox-error))
(define example (make-lox-error (vector 0 1 2 3)))
(test-assert (lox-error? example))

(test-assert (vector= = (vector 0 1 2 3)
                      (lox-error-where example)))
;; lox-where needs to be a vector
(test-assert (vector? (lox-error-where example)))
;; it needs t

(test-error &todo-error (raise-exception example))
(test-end "lox-error")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lox-lexer-error
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(test-begin "lox-lexer-error")
;; corrent building
(define a (make-lox-lexer-error (vector 1 2 3 4)
                                "string"))
;; is subclass of lox-error
(test-assert (lox-error? a))
;; correct error type
(test-assert (lox-lexer-error? a))
;; contains same fields
(test-assert (vector? (lox-error-where a)))
;; same values
(test-assert (vector= = (lox-error-where a) (vector 1 2 3 4)))

;; it has its own field
(test-assert (string? (lox-lexer-error-lexeme a)))
;; correct storage
(test-assert (string= "string"
                      (lox-lexer-error-lexeme a)))
(test-end "lox-lexer-error")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lox-scan-string-error
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
