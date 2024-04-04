;; somehow I am going to place error handling functions in here.
;; create custom error types
(define-module (glox error))
(use-modules (glox char)
             (glox utils))
(use-modules (ice-9 exceptions))

(define STARTPOS 0)
                        
;; error type, denotes when a function should be worked on
;; this is a macro
(define-exception-type &todo-error
                       &programming-error 
                       make-todo-error todo-error?)
(export &todo-error
        make-todo-error
        todo-error?
        STARTPOS)

;; denotes generic lox-error
(define-exception-type &lox-error
                       &programming-error
                       make-lox-error
                       lox-error?
                       (where lox-error-where)) ;; is a pair detailing location
                      ;; (vec start-line start-column end-line end-coloum) 
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

(define-exception-type &scan-string-error
                       &lox-lexer-error
                       make-scan-string-error
                       scan-string-error?)

(export &scan-string-error
        make-scan-string-error
        scan-string-error?)

;; PARSER
(define-exception-type &lox-parser-error
                       &lox-error
                       make-lox-parser-error
                       lox-parser-error?)


(export &lox-parser-error
        make-lox-parser-error
        lox-parser-error?)

(define (lexer-exception-handler ex)
  (format (current-error-port)
          "Type: ~20s, Where: ~20s, Lexeme: %s~%"
          (exception-kind ex)
          (lox-error-where ex)
          (lox-lexer-error-lexeme ex))) 

(export lexer-exception-handler)
