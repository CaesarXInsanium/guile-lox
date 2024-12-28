(use-modules (glox error)
             (glox char)
             (glox utils)
             (ice-9 exceptions)
             (srfi srfi-43)
             ;; testing
             (srfi srfi-64))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sanity checks
(test-begin "todo")
(test-error #t (todo! 'symbol))
(test-end "todo")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOX ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(test-begin "lox-error")

(test-assert (exception-type? &lox-error))

;; does it require the damn message?
;; (make message line)
(define example (make-lox-error "something something" 0))
(test-assert (exception-type? &lox-error))
(test-assert (lox-error? example))
(test-assert (= 0 (lox-error-where example)))
;; lox-where needs to be a vector
(test-assert (exact-integer? (lox-error-where example)))

(test-end "lox-error")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOX LEXER ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(test-begin "lox-lexer-error")
;; corrent building
;; (make message line lexeme)
(define a (make-lox-lexer-error "message" 0 "lexeme"))
;; is subclass of lox-error
(test-assert (lox-error? a))
;; correct error type
(test-assert (lox-lexer-error? a))
;; contains same fields
(test-assert (exact-integer? (lox-error-where a)))
(test-equal 0 (lox-error-where a))

;; this is how to access the thing
(test-assert (string? (exception-message a)))
(test-assert (string=? (exception-message a) "message"))
;; same values

;; it has its own field
(test-assert (string? (lox-lexer-error-lexeme a)))
;; correct storage
(test-assert (string=? "lexeme"
                      (lox-lexer-error-lexeme a)))
(test-end "lox-lexer-error")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOX PARSER ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(test-begin "lox-parser-error")
(define b (make-lox-parser-error "Funny Message" 0 "Stupid AST"))
(test-assert (lox-error? b))
(test-assert (lox-parser-error? b))
(test-end "lox-parser-error")
