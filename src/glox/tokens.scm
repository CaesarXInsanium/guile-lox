(define-module (glox tokens))
;; allows for defining records

(use-modules (srfi srfi-9)
             (srfi srfi-9 gnu)
             (ice-9 format) ;; custom printer
             (ice-9 hash-table))

(define NIL '())
;; simple type
(define-record-type token
  (make-token type lexeme object line)
  token?
  (type token-type)
  (lexeme token-lexeme)
  (object token-object)
  (line token-line))


(set-record-type-printer! token 
                          (lambda (record port)
                            (display (format #f "Type: ~s,\tLexeme: ~s,\tObject: ~:a,\tLine: ~d~%"
                                             (symbol->string (token-type record))
                                             (token-lexeme record)
                                             (token-object record) ;; will have to live with this horror
                                             (token-line record))
                                     port)))

;; alist defining the token TYPES
(define tokenb '((TOKEN_LEFT_PAREN . "TOKEN_LEFT_PAREN")
                 (TOKEN_RIGHT_PAREN . "TOKEN_RIGHT_PAREN")
                 (TOKEN_LEFT_BRACE . "TOKEN_LEFT_BRACE")
                 (TOKEN_RIGHT_BRACE . "TOKEN_RIGHT_BRACE")
                 (TOKEN_COMMA . "TOKEN_COMMA")
                 (TOKEN_DOT . "TOKEN_DOT")
                 (TOKEN_MINUS . "TOKEN_MINUS")
                 (TOKEN_PLUS . "TOKEN_PLUS")
                 (TOKEN_SEMICOLON . "TOKEN_SEMICOLON")
                 (TOKEN_SLASH . "TOKEN_SLASH")
                 (TOKEN_STAR . "TOKEN_STAR")

                 ;; Two Char
                 (TOKEN_BANG . "TOKEN_BANG")
                 (TOKEN_BANG_EQUAL . "TOKEN_BANG_EQUAL")
                 (TOKEN_EQUAL . "TOKEN_EQUAL")
                 (TOKEN_EQUAL_EQUAL . "TOKEN_EQUAL_EQUAL")
                 (TOKEN_GREATER . "TOKEN_GREATER")
                 (TOKEN_GREATER_EQUAL . "TOKEN_GREATER_EQUAL")
                 (TOKEN_LESS . "TOKEN_LESS")
                 (TOKEN_LESS_EQUAL . "TOKEN_LESS_EQUAL")

                 ;; Literals
                 (TOKEN_IDENTIFIER . "TOKEN_IDENTIFIER")
                 (TOKEN_STRING . "TOKEN_STRING")
                 (TOKEN_NUMBER . "TOKEN_NUMBER")

                 ;; KEYWORDS
                 (TOKEN_AND . "TOKEN_AND")
                 (TOKEN_CLASS . "TOKEN_CLASS")
                 (TOKEN_ELSE . "TOKEN_ELSE")
                 (TOKEN_FALSE . "TOKEN_FALSE")
                 (TOKEN_FUN . "TOKEN_FUN")
                 (TOKEN_FOR . "TOKEN_FOR")
                 (TOKEN_IF . "TOKEN_IF")
                 (TOKEN_NIL . "TOKEN_NIL")
                 (TOKEN_OR . "TOKEN_OR")
                 (TOKEN_PRINT . "TOKEN_PRINT")
                 (TOKEN_RETURN . "TOKEN_RETURN")
                 (TOKEN_SUPER . "TOKEN_SUPER")
                 (TOKEN_THIS . "TOKEN_THIS")
                 (TOKEN_TRUE . "TOKEN_TRUE")
                 (TOKEN_VAR . "TOKEN_VAR")
                 (TOKEN_WHILE . "TOKEN_WHILE")

                 (TOKEN_EOF . "TOKEN_EOF")
                 (TOKEN_ERROR . "TOKEN_ERROR")))
                 
(define token-types (alist->hash-table tokenb))                 
  
(define keywords (alist->hash-table '(("and" . TOKEN_AND)
                                      ("class" . TOKEN_CLASS)
                                      ("else" . TOKEN_ELSE)
                                      ("false" . TOKEN_FALSE)
                                      ("fun" . TOKEN_FUN)
                                      ("for" . TOKEN_FOR)
                                      ("if" . TOKEN_IF)
                                      ("nil" . TOKEN_NIL)
                                      ("or" . TOKEN_OR)
                                      ("print" . TOKEN_PRINT)
                                      ("return" . TOKEN_RETURN)
                                      ("super" . TOKEN_SUPER)
                                      ("this" . TOKEN_THIS)
                                      ("true" . TOKEN_TRUE)
                                      ("var" . TOKEN_VAR)
                                      ("while" . TOKEN_WHILE))))

(define (keyword? str)
  (let ((handle (hash-get-handle keywords)))
    (if (pair? handle)
      (cdr handle)
      'TOKEN_IDENTIFIER)))

(define (make-error-token port)
  (make-token 'TOKEN_ERROR "ERROR" NIL (port-line port)))

(define (make-eof-token port)
  (make-token 'TOKEN_EOF "EOF" NIL (port-line port))) 

(export token-types
        token
        make-token
        token-type
        token-lexeme
        token-object
        token-line
        keywords
        keyword?
        make-error-token
        make-eof-token)
