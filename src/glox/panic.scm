(define-module (glox panic)
               #:export (panic!))

(define rnrs-error (@ (rnrs base) error))
;; TODO play with false-if-exception
(define (panic! sym msg . weird-data)
  (format #t "PANIC!~%")
  (rnrs-error sym msg weird-data))
