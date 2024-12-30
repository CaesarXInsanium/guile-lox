(define-module (glox parser)
               #:use-module (glox utils)
               #:use-module (glox error)
               #:use-module (srfi srfi-1)
               #:use-module (glox tokens)
               #:export (parse-tokens print-ast expr? 
                                      parser-token-pred
                                      make-unary unary? 
                                      make-binary? binary?
                                      make-grouping grouping?
                                      make-statement statement?
                                      make-literal literal?))
                                      


(define (make-program . statements)
  (map (lambda (state)
         (if (statement? state)
           (todo! 'make-program)
           (todo! 'make-program)))
       statements))

;; Predicates

(define (expr? sym) 
  (one-true? (binary? sym)
             (grouping? sym)
             (literal? sym)
             (unary? sym)))


(define (print-ast ast) (todo! 'print-ast))

(define (parse-tokens tokens) (todo! 'parse-tokens))

(define (binary? sym) (todo! 'binary?))
(define (make-binary left operator right) (todo! 'make-binary))

(define (unary? sym) (todo! 'unary))
(define (make-unary operator sym) (todo! 'make-unary))

(define (grouping? sym) (todo! 'grouping?))
(define (make-grouping expr) (todo! 'make-grouping))

(define (statement? sym) (todo! 'statement?))
(define (make-statement sym) (todo! 'make-statement))

(define (literal? token) (todo! 'literal?))
(define (make-literal token) (todo! make-literal))

(define-syntax parser-token-pred
  (syntax-rules ()
    ((_ valid-types)
     (lambda (token)
       (let ((t (token-type token)))
        (any (lambda (l) (eq? t l))
             valid-types))))))

(define terminal? (parser-token-pred '(TOKEN_STRING TOKEN_FLOAT TOKEN_TRUE TOKEN_FALSE)))
