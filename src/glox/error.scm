;; somehow I am going to place error handling functions in here.
;; create custom error types
(define-module (glox error)
               #:use-module (glox char)
               #:use-module (glox utils)
               #:use-module (ice-9 exceptions)
               #:export (todo! make-error-message))

;; Now the question becomes, should I use R6Rs valid scheme or GNU Guile?
;; Answer GNU Guile

;; error type, denotes when a function should be worked on
;; this is a macro
(define (todo! sym) 
  (error (format #f "Function/Variable ~s not defined" 
                 (if (symbol? sym)
                   (symbol->string sym)
                   sym))))

;; Error Codes are in Ranges
;; 0 SUCCESS
;; 1-99 Lexer
;; 100-199 Parser
;; 
(define error-reasons '((UNREACHABLE . -1)
                        (SUCCESS . 0) 
                        (EARLY_EOF . 1) 
                        (EARLY_NEWLINE . 2) 
                        (UNSUPPORTED_CHAR . 3)
                        (UNRECOGNIZED_CHAR . 4)))

;; assumes that sym is symbol, reason is also a symbol
(define (make-error-message caller reason)
  (format #t "Caller: ~s~%Reason: ~s~%" caller reason))

(define (explain-reason re) (todo! 'explain-reason))

;; denotes generic lox-error, with just a message. Vague error meant to convey
;; the idea that something is wrong with interpreter/compiler code
(define-exception-type &lox-error
                       &message
                       make-lox-error
                       lox-error?)


(export &lox-error
        make-lox-error
        lox-error?)

;; by default it should inherit the fields of &lox-error
;; contains the port, so that the error handler can pick it apart and learn about
;; the place where the error occurred.
(define-exception-type &lox-lexer-error
                       &lox-error
                       make-lox-lexer-error
                       lox-lexer-error?
                       (port lox-lexer-error-port))

;; the port is that of a string port. so port-line and port-coloumn are valid
;; this makes sense since port is actually the open-input-string port, no STDIN
;; or the file/io port
(define (lexer-exception-handler ex)
  (let ((lex-port (lox-lexer-error-port ex)))
    (format (current-error-port)
            "[~s/~s], ftell: ~3s~%Error Message: ~20s"
            (port-line lex-port)
            (port-column lex-port)
            (ftell lex-port)
            (exception-message ex))))

(export &lox-lexer-error
        make-lox-lexer-error
        lox-lexer-error?
        lox-lexer-error-port
        lexer-exception-handler)

;; PARSER
(define-exception-type &lox-parser-error
                       &lox-error
                       make-lox-parser-error
                       lox-parser-error?
                       ;; returns current state of the AST
                       (ast lox-parser-error-ast))


(export &lox-parser-error
        make-lox-parser-error
        lox-parser-error?
        lox-parser-error-ast)

;; Evaluator

(define (lox-error-handler ex)
  (cond ((lox-compiler-error? ex) (todo! '&lox-compiler))
        ((lox-interpreter-error? ex) (todo! '&lox-interpreter))
        ((lox-parser-error? ex) (todo! '&lox-parser))
        ((lox-lexer-error? ex) (format (current-error-port)
                                       "Message: ~s~%"
                                       (exception-message ex)))))

