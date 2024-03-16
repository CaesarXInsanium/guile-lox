(define-module (glox scanner))
(use-modules (ice-9 textual-ports)
             (glox char)
             (glox tokens))

(define NIL '())

;; the next get-char WILL return a quote
;; end scanning on reach a second quote
;; we can have optional arguments
;; by default missing optional arguments have a false
;; all scheme object are inherently the boolean true
;;(define (scan-string port
 ;;                    #:optional
;;                      start
  ;;                   line
   ;;                  lexeme))

;; end with this
;;(cons (make-token type lexeme literal line)
      ;;(scan-tokens port))

;; (define (scan-number port #:key start))

;; 
;; simply scan until we hit a newline, space
;; (define (scan-identifier port))

;; scanning single char tokens is rather easy, we just need the port line and column
(define (scan port)
  (let ((char (get-char port)))
    (cond ((eof-object? char) (cons (make-eof-token port) NIL)) 
          ((single-char? char) (cons (make-token (single-char? char)
                                         (list->string (list char))
                                         NIL
                                         (port-line port))
                                     (scan port)))
          (else (cons (make-error-token port) (scan port))))))

(export scan)
