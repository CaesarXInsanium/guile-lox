(use-modules (glox)
             (glox scanner)
             (glox parser)
             (glox tokens)
             (glox utils)
             (glox error)
             (srfi srfi-64)
             (ice-9 textual-ports))

(test-begin "expr?")
(test-assert (procedure? expr?))
(test-end "expr?")

(test-begin "literal")
(define string-one "1")
(define token-one (make-token 'TOKEN_NUMBER "1" NIL 0))
(define A (make-literal token-one))
(test-end "literal")

(test-begin "expressions")
(define A "1+1")
(define a1 '(+ 1 1))
(define a 
  (make-expr 
    (make-binary (make-literal 1) 
                 (make-operator '+)
                 (make-literal 1))))

(define a2 (list 'BINARY 
                 (list 'NUMBER 1)
                 (list 'OPERATOR '+)
                 (list 'NUMBER 1)))

(define b-src "1 - (2 * 3) < 4 == false")
(define b-tokens (scan b-src))
                 
(test-assert (expr? a))
(test-begin "expressions")
