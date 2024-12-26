(use-modules (glox scanner)
             (glox tokens)
             (glox utils)
             (srfi srfi-64)
             (ice-9 textual-ports)
             (glox error))

(test-begin "token")
(define a (make-token 'TOKEN_NUMBER "69" NIL 0))
(define b (make-token 'TOKEN_NUMBER "69" NIL 0))

;; sanity checks
(test-assert (token? a))
(test-assert (token? b))

(test-assert (token=? a b))

(define c (make-error-token (open-input-string "var = \"jesus\"")))
(test-assert (error-token? c))
                      
(test-end "token")
