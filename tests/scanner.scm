;; testing for the project
(use-modules (glox scanner)
             (glox tokens)
             (glox utils)
             (srfi srfi-64)
             (ice-9 textual-ports)
             (glox error))

(test-begin "scan-string")
(define sample-string "\"string value\"")
;; scan-string calls scan
(define tok (car (scan-string (open-input-string sample-string))))
;; item returned is a token!
(test-assert (token? tok))
;; there is no procedure to test token equality
(test-assert (procedure? token=?))

(test-assert (token=? tok (make-token 'TOKEN_STRING
                                      "\"string value\""
                                       NIL
                                       0)))
(test-end "scan-string")
