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
