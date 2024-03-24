(define-module (glox char))
(define NIL '())

(define whitespace? 
  (lambda (char)
    (or (char=? char #\newline)
        (char=? char #\tab)
        (char=? char #\space))))
                      

(define (alpha? char)
  (or (or (and (char>=? char #\a) 
               (char<=? char #\z)) 
          (and (char>=? char #\A)
               (char<=? char #\Z)))
      (char=? char #\_)))

(define (digit? char)
  (and (char>=? char #\0) (char<=? char #\9)))

(define (period? char) (char=? char #\.))

(define (num-symbol? char) (or (digit? char) (period? char)))

;; ending condition for stopping the scanning of numbers
(define (end-num? char) (or (alpha? char)
                            (whitespace? char)
                            (alpha-symbol? char)))

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

(define (char->string . char) (list->string char))

;; double tokens
(define (bang? a) (char=? #\! a))
(define (eql? a) (char=? #\= a))
(define (cmp? a) (or (char=? #\< a) (char=? #\> a)))
(define (comment? a b) (and (char=? #\/ a) (char=? #\/ b)))
(define (slash? a) (char=? #\/ a))

(define (double? char)
  (or (bang? char)
      (eql? char)
      (cmp? char)
      (slash? char)))

(export whitespace?
        digit?
        alpha?
        alpha-numeric?
        alpha-symbol?
        quote-mark?
        single-char?
        char->string
        bang?
        eql?
        cmp?
        comment?
        slash?
        double?
        period?
        num-symbol?
        end-num?)
        
