(define-module (glox utils)
  #:use-module (glox char)
  #:use-module (glox tokens)
  #:use-module (ice-9 textual-ports)
  #:export (revstr NIL reverse-string option? unwrap wrap some none none? some?
                   one-true?))

(define NIL '())

;; assumes a list of chars
;; reverses list of char and then transforms to a string
(define (revstr lst) 
  (list->string (reverse lst)))

(define (reverse-string str) (list->string (reverse (string->list str))))


;; assumes that fseek and ftell are valid

(define option? list?)
(define (unwrap x)
  (if (list? x)
      (if (null? x)
       (error "Empty Monad")
       (list-ref x 0))
      (error "Not a Monad")))
(define (wrap x) (list x))

(define (some x) (list x))
(define (none) '())

(define none?
  (lambda (x)
    (and (list? x) (null? x))))

(define some? (lambda (x) (not (none? x))))

(define (one-true? lst)
  "Returns #t if and only if exactly one item in the list is true, otherwise returns #f."
  (cond
    ((null? lst) #f)
    ((and (not (car lst))
          (every not (cdr lst))) #f) ; No true values
    ((and (car lst) (every not (cdr lst))) #t) ; Only first item is true
    (else (one-true? (cdr lst))))) ; Check remaining list
