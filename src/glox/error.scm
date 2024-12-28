;; somehow I am going to place error handling functions in here.
;; create custom error types
(define-module (glox error)
               #:use-module (glox char)
               #:use-module (glox utils)
               #:use-module (ice-9 exceptions)
               #:export (todo!))

;; Now the question becomes, should I use R6Rs valid scheme or GNU Guile?
;; Answer GNU Guile

;; error type, denotes when a function should be worked on
;; this is a macro
(define (todo! sym) 
  (error (format #f "Function/Variable ~s not defined" 
                 (if (symbol? sym)
                   (symbol->string sym)
                   sym))))

;; denotes generic lox-error
(define-exception-type &lox-error
                       &message
                       make-lox-error
                       lox-error?
                       (where lox-error-where)) ;; value from (ftell port)
                      ;; (vec start-line start-column end-line end-coloum) 

(define valid-port-location? exact-integer?)

(export &lox-error
        make-lox-error
        lox-error?
        lox-error-where)

;; by default it should inherit the fields of &lox-error
(define-exception-type &lox-lexer-error
                       &lox-error
                       make-lox-lexer-error
                       lox-lexer-error?
                       (lexeme lox-lexer-error-lexeme))

(export &lox-lexer-error
        make-lox-lexer-error
        lox-lexer-error?
        lox-lexer-error-lexeme)

;; PARSER
(define-exception-type &lox-parser-error
                       &lox-error
                       make-lox-parser-error
                       lox-parser-error?
                       (ast lox-parser-error-ast))


(export &lox-parser-error
        make-lox-parser-error
        lox-parser-error?)

;; Evaluator

(define (lexer-exception-handler ex)
  (format (current-error-port)
          "Lexer Error ~20s, Line: ~20s, Lexeme: ~s"
          (exception-kind ex)
          (lox-error-where ex)
          (lox-lexer-error-lexeme ex))) 

(define (lox-error-handler ex)
  (cond ((lox-compiler-error? ex) (todo! '&lox-compiler))
        ((lox-interpreter-error? ex) (todo! '&lox-interpreter))
        ((lox-parser-error? ex) (todo! '&lox-parser))
        ((lox-lexer-error? ex) (format (current-error-port)
                                       "Message: ~s~%"
                                       (exception-message ex)))))

(export lexer-exception-handler)
