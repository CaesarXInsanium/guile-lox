(define-module (glox utils)
  #:use-module (glox char)
  #:use-module (glox tokens)
  #:use-module (ice-9 textual-ports)
  #:export (revstr NIL reverse-string option? unwrap wrap some none none? some?
                   get-all-line))

(define NIL '())

;; assumes a list of chars
;; reverses list of char and then transforms to a string
(define (revstr lst) 
  (list->string (reverse lst)))

(define (reverse-string str) (list->string (reverse (string->list str))))

;; assumes that fseek and ftell are valid
(define (get-all-line port)
  (let ((c (port-column port))
        (f (ftell port)))
    (begin (seek port (- f c) SEEK_SET)
           (let ((str (get-line port)))
             (close-port port)
             str))))

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

