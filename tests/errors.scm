(use-modules (glox error)
             (glox char)
             (glox utils)
             (ice-9 exceptions)
             (srfi srfi-43)
             ;; testing
             (srfi srfi-64))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TO DO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(test-begin "to do")

(test-error #t (todo! 'symbol))

(test-end "to do")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOX ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(test-begin "lox-error")

(test-assert (exception-type? &lox-error))
;; (make message line)
(define example (make-lox-error "something something"))
(test-assert (exception-type? &lox-error))
(test-assert (lox-error? example))

(test-end "lox-error")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOX LEXER ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(test-begin "lox-lexer-error")

(define m "message")
(define n "Random Input String")
;; corrent building
;; (make message line lexeme)
(define a (make-lox-lexer-error m  (open-input-string n)))
;; is subclass of lox-error
(test-assert (lox-error? a))
;; correct error type
(test-assert (lox-lexer-error? a))
;; contains same fields
(test-assert (port? (lox-lexer-error-port a)))
(test-assert (exact-integer? (ftell (lox-lexer-error-port a))))
;; this is how to access the thing
(test-assert (string? (exception-message a)))
(test-assert (string=? (exception-message a) "message"))

(test-end "lox-lexer-error")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOX PARSER ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(test-begin "lox-parser-error")
(define b (make-lox-parser-error "Funny Message" "Stupid AST"))
(test-assert (lox-error? b))
(test-assert (lox-parser-error? b))
(test-end "lox-parser-error")
