(define-module (glox utils)
  #:use-module (glox char)
  #:use-module (glox tokens)
  #:use-module (ice-9 textual-ports)
  #:export (revstr ignore-line NIL))

(define NIL '())

;; assumes a list of chars
(define (revstr lst) 
  (list->string (reverse lst)))


;; continue is a function that accepts a port as an argument
(define (ignore-line port continue)
  (get-line port)
  (continue port))

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

