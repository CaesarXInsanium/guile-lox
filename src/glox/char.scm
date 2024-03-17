(define-module (glox char))
(define NIL '())

(define whitespace? char-whitespace?)

(define (alpha? char)
  (or (or (and (char>=? char #\a) 
               (char<=? char #\z)) 
          (and (char>=? char #\A)
               (char<=? char #\Z)))
      (char=? char #\_)))

(define (digit? char)
  (and (char>=? char #\0) (char<=? char #\9)))

(define (alpha-numeric? char)
  (or (alpha? char) (digit? char)))

(define (alpha-symbol? char)
  (or (char=? char #\-) (char=? char #\_)))

(define (quote-mark? char) (or (char=? #\" char) (char=? #\' char)))

(define (single-char? char)
  (cond ((char=? char #\() 'TOKEN_LEFT_PAREN)
        ((char=? char #\)) 'TOKEN_RIGHT_PAREN)
        ((char=? char #\{) 'TOKEN_LEFT_BRACE)
        ((char=? char #\}) 'TOKEN_RIGHT_BRACE)
        ((char=? char #\,) 'TOKEN_COMMA)
        ((char=? char #\.) 'TOKEN_DOT)
        ((char=? char #\-) 'TOKEN_MINUS)
        ((char=? char #\+) 'TOKEN_PLUS)
        ((char=? char #\;) 'TOKEN_SEMICOLON)
        ((char=? char #\*) 'TOKEN_STAR)
        (else #f)))

(define (char->string char) (list->string (list char)))

(export whitespace?
        digit?
        alpha?
        alpha-numeric?
        alpha-symbol?
        quote-mark?
        single-char?)
