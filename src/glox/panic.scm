(define-module (glox panic)
               #:export (panic! unreachable! todo!))

(define rnrs-error (@ (rnrs base) error))
;; TODO play with false-if-exception

(define (panic! sym msg . weird-data)
  (rnrs-error sym (string-concatenate (list (format #f "PANIC!~%") msg)) weird-data))

(define (unreachable! sym . data)
  (panic! sym "UNREACHABLE?"))

;; sym and reason are symbols
(define* (todo! sym #:optional reason weird-data)
  (rnrs-error sym (format #f "TODO! ~s" reason) weird-data))
