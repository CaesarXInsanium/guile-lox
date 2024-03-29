(define-module (glox scanner)
  #:use-module (ice-9 textual-ports)
  #:use-module (glox char)
  #:use-module (glox tokens)
  #:use-module (glox utils)
  #:export (scan scan-number scan-bang scan-cmp scan-slash scan-op
                 scan-eql scan-identifier scan-string))


;; a is consumed
;; b is peeked
(define (scan-bang port a b)
  (if (char=? b #\=)
    (cons (make-token 'TOKEN_BANG_EQUAL 
                     (char->string a (get-char port)) 
                     NIL 
                     (port-line port))
          (scan port))
    (cons (make-token 'TOKEN_BANG 
                      (char->string a) 
                      NIL 
                      (port-line port))
      (scan port))))

(define (scan-eql port a b)
  (if (char=? b #\=)
    (cons (make-token 'TOKEN_EQUAL_EQUAL 
                      (char->string a (get-char port)) 
                      NIL 
                      (port-line port))
          (scan port))
          
    (cons (make-token 'TOKEN_EQUAL (char->string a) NIL (port-line port))
          (scan port))))

(define (scan-cmp port a b)
  (if (char=? b #\=)
    (cond ((char=? a #\<) (cons (make-token 'TOKEN_LESS_EQUAL
                                            (revstr (list a b))
                                            NIL
                                            (port-line port))
                                (scan-port)))
          ((char=? a #\>) (cons (make-token 'TOKEN_GREATER_EQUAL
                                            (revstr (list a b))
                                            NIL
                                            (port-line port))
                                (scan port)))
          (else (error "error unreachable in scan-cmp")))
    (cond ((char=? a #\<) (cons (make-token 'TOKEN_LESS
                                            (revstr (list a))
                                            NIL
                                            (port-line port))
                                (scan port)))
          ((char=? a #\>) (cons (make-token 'TOKEN_GREATER
                                            (revstr (list a))
                                            NIL
                                            (port-line port))
                                (scan port)))
          (else (error "This error should be unreachable in scan-cmp")))))

;; division, a is guranteed / character
(define (scan-slash port a b)
  (cons (make-token 'TOKEN_SLASH
                    (revstr (list a))
                    NIL
                    (port-line port))
        (scan port)))

;; the char is from pair char which is member of double or single tokens
(define* (scan-op port #:optional str)
  (let ((a (get-char port))
        (b (lookahead-char port)))
    (cond ((bang? a) (scan-bang port a b)) 
          ((eql? a) (scan-eql port a b))
          ;; > or <
          ((cmp? a) (scan-cmp port a b))
          ((comment? a b) (ignore-line port scan))
          ((slash? a) (scan-slash port a b))
          ((eof-object? b) (error "FUCKING EOF found in scan-op"))
          (else (error "Invalid OP")))))

;; (define (scan-number port #:key start))

;; simply scan until we hit a whitespace, parens, braces, 
;; whitespace or not alpha-numeric?
(define* (scan-identifier port #:optional start str)
  (let ((char (get-char port)))
    (if (and start str)
      (cond ((eof-object? char) (error "EOF found in scan-identifier")) 
            ((or (alpha-symbol? char) (alpha-numeric? char)) 
             (scan-identifier port start (cons char str)))
            ;; if it is whitespace, we should exclude the char, put it back
            ((or (single-char? char) (whitespace? char) (double? char)) 
             (cons (make-token (lox-keyword? (revstr str))
                         (revstr str)
                         NIL
                         (port-line port))
                   (begin (unget-char port char) 
                          (scan port))))
            (else (error (format #f 
                                 "Port: ~s, Char: ~s, Numeric?: ~s, Whitespace?: ~s, str: ~s"
                                 port
                                 char
                                 (digit? char)
                                 (whitespace? char)
                                 str))))
      (scan-identifier port 0 (cons char NIL)))))
                                                  

;; scanning single char tokens is rather easy, we just need the port line and column
;; start is column where string starts, newlines are not handled
;; str will be the current progress, list of characters
;; must handle a situation where it finds a EOF marker
(define* (scan-string port #:optional str)
         (let ((char (get-char port)))
           (cond ((eof-object? char) (error "EOF object found scan-string, unterminated?"))
                 ((and (quote-mark? char) str)
                  (cons (make-token 'TOKEN_STRING
                                    (revstr (cons char str))
                                    NIL
                                    (port-line port))
                                   
                        (scan port)))
                 ((and (not (quote-mark? char)) str)
                  (scan-string port (cons char str)))
                 (else (scan-string port (cons char NIL))))))

;; it MUST start with digit, can only contain one period
;; in order to support floats
;; on first call, char is guaranteed to be digit?
;; the only solution is to split this shit into two seperate functions
;; state is represented with functions
(define* (scan-number port #:optional digits)
         (let ((char (lookahead-char port)))
          (cond ((eof-object? char) (error "EOF object found in scan-number"))
                ((not digits) (scan-number port (cons (get-char port) NIL)))
                ((period? char) (scan-float port (cons (get-char port) 
                                                       digits)))
                ((digit? char) (scan-number port (cons (get-char port)
                                                       digits)))
                (else (cons (make-token 'TOKEN_NUMBER
                                      (revstr digits)
                                      NIL
                                      (port-line port))
                            (scan port))))))

(define (scan-float port digits)
  (let ((char (lookahead-char port)))
    (cond ((eof-object? char) (error "EOF object found in scan-float"))
          ((digit? char) (scan-float port (cons (get-char port) digits)))
          ((and (period? (car digits)) (not (digit? char)))
           (error "non digit found after period in float literal"))
          (else (cons (make-token 'TOKEN_NUMBER
                                  (revstr digits)
                                  NIL
                                  (port-line port))
                      (scan port))))))
                  

(define (scan port)
 ;; we need to peek here
  (let ((char (lookahead-char port)))
    (cond ((eof-object? char) (cons (make-eof-token port) NIL)) 
          ;; tokens comprising of single char
          ((single-char? char) (cons (make-token (single-char? (get-char port))
                                                 (revstr (list char))
                                                 NIL
                                                 (port-line port))
                                     (scan port)))
          ;; two character operators and comments
          ((double? char) (scan-op port))
          ;; strings
          ((quote-mark? char) (scan-string port))
          ;; identifier or keyword?
          ((alpha? char) (scan-identifier port))
          ;; whitespace is ignored, consume token and continue
          ((whitespace? char) (begin (get-char port)
                                     (scan port)))
          ((digit? char) (scan-number port))
          (else (cons (make-error-token port) (scan port))))))

