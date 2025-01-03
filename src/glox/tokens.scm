(define-module (glox tokens)
  #:use-module (glox utils)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-9 gnu)
  #:use-module (ice-9 hash-table)
  #:use-module (ice-9 format)
  #:use-module (ice-9 textual-ports)
  #:export (token-types
            token?
            token=?
            make-token
            token-type
            token-lexeme
            token-object
            token-line
            keywords
            lox-keyword?
            make-error-token
            error-token?
            make-eof-token
            eof-token?))

;; simple type
(define-record-type token
  (make-token type lexeme object line)
  token?
  (type token-type)
  (lexeme token-lexeme)
  (object token-object)
  (line token-line))

;; What sort of things would take to mean two tokens are equal or equivalent?
;; same thing in memory can be done with eq?
;; depends on TOKEN type
;; keywords are all inherently the same

;; check if TYPES are the same, return false if no
;; 
(define unique-toks (list 'TOKEN_IDENTIFIER
                          'TOKEN_STRING
                          'TOKEN_NUMBER))

(define (token=? a b)
  (let ((at (token-type a))
        (bt (token-type b)))
    ;; assert that the types are equal
    (and (eq? at bt)
         ;; of at is in list unique-toks, check equality for the lexemes
         (let ((result (memq at unique-toks)))
           (if result (string=? (token-lexeme a) (token-lexeme b)) #t)))))

(define token-printer 
  (lambda (record port)
        (format port "Type: ~20a Line ~3d, Lexeme ~20s, Object ~20s ~%"
                         (symbol->string (token-type record))
                         (token-line record) ;; will have to live with this horror
                         (token-lexeme record)
                         (token-object record))))

(set-record-type-printer! token token-printer) 
                          
                                     

;; alist defining the token TYPE
;; singlechar TOKS are inherently always same token
;; so are double chars no need to check line numbers
(define tokenb '((TOKEN_LEFT_PAREN . "TOKEN_LEFT_PAREN")
                 (TOKEN_RIGHT_PAREN . "TOKEN_RIGHT_PAREN")
                 (TOKEN_LEFT_BRACE . "TOKEN_LEFT_BRACE")
                 (TOKEN_RIGHT_BRACE . "TOKE_RIGHT_BRACE")
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

                 (TOKEN_TRUE . "TOKEN_TRUE")
                 (TOKEN_FALSE . "TOKEN_FALSE")

                 ;; KEYWORDS
                 (TOKEN_AND . "TOKEN_AND")
                 (TOKEN_CLASS . "TOKEN_CLASS")
                 (TOKEN_ELSE . "TOKEN_ELSE")
                 (TOKEN_FUN . "TOKEN_FUN")
                 (TOKEN_FOR . "TOKEN_FOR")
                 (TOKEN_IF . "TOKEN_IF")
                 (TOKEN_NIL . "TOKEN_NIL")
                 (TOKEN_OR . "TOKEN_OR")
                 (TOKEN_PRINT . "TOKEN_PRINT")
                 (TOKEN_RETURN . "TOKEN_RETURN")
                 (TOKEN_SUPER . "TOKEN_SUPER")
                 (TOKEN_THIS . "TOKEN_THIS")
                 (TOKEN_VAR . "TOKEN_VAR")
                 (TOKEN_WHILE . "TOKEN_WHILE")

                 (TOKEN_EOF . "TOKEN_EOF")
                 ;; TOKEN ERROR
                 (TOKEN_ERROR . "TOKEN_ERROR")))
                 
;; use hash table for SPEED
(define token-types (alist->hash-table tokenb))                 
  
(define keywords 
  (alist->hash-table '(("and" . TOKEN_AND)
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

(define (lox-keyword? str)
  (let ((handle (hash-get-handle keywords str)))
    (if (pair? handle)
      (cdr handle)
      'TOKEN_IDENTIFIER)))

;; Question becomes, is it possible to recover?
;; Answer should be no. Error in tokens means that that this shit cant be parsed
(define (make-error-token port)
  ;; i need to consume the char
  (let* ((pos (ftell port))
         (col (port-column port))
         (startofline (- pos col))
         (line (get-line port)))
    (seek port pos SEEK_SET)
    (make-token 'TOKEN_ERROR (format #f "String: ~s" line) NIL (port-line port))))

;; should this function close the port? IDK, only with the REPL maybe?
(define (make-eof-token port)
  (make-token 'TOKEN_EOF "EOF" NIL (port-line port))) 

(define-syntax make-token-predicate
  (syntax-rules () 
    ((_ token-sym)
     (lambda (x) (and (token? x)
                      (eq? token-sym (token-type x)))))))

(define eof-token? (make-token-predicate 'TOKEN_EOF))
(define error-token? (make-token-predicate 'TOKEN_ERROR))
