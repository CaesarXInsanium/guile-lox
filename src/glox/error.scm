;; somehow I am going to place error handling functions in here.
;; create custom error types
(define-module (glox error)
  #:use-module (glox char)
  #:export (TODO make-lexer-error make-parser-error))

;; should only be called within context of a function
;; passed variable function is a symbol
(define (TODO function port)
  (error (format port 
                 "(~s) function is not implemented" 
                 (symbol->string function))))

;; macro to tell programmer to do the actual work.
;; create a Custom error
(define (make-lexer-error function port start-column))

(define (make-parser-error token) (error))
