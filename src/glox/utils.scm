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
