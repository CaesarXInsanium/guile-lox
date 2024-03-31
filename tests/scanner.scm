;; testing for the project
(use-modules (glox scanner)
             (glox tokens)
             (glox utils)
             (srfi srfi-64)
             (ice-9 textual-ports)
             (glox error))

(test-begin "scan-string")
(define number "\"string value\"")
(define tok (car (scan-string (open-input-string number))))
;; item returned is a token!
(test-assert (token? tok))

;; token is equal to given
;(test-eq tok
; ;       (make-token 'TOKEN_STRING
;                    "\"string value\""
;                    NIL
;                    0))

;; rudamentary error
;; should return LOX_UNTERMINATED_STRING
(test-error &scan-string-error
            (car (scan-string (open-input-string "\"asdasdasd"))))
            

(test-end "scan-string")
