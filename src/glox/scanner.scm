(define-module (glox scanner))
(use-modules (ice-9 textual-ports)
             (glox char)
             (glox tokens))

(define NIL '())

(define (revstr lst) (list->string (reverse lst)))

(define (ignore-line port)
  (get-line port)
  (scan port))

;; a is consumed
;; b is peeked
(define (scan-bang port a b)
  (if (char=? b #\=)
    (cons (make-token 'TOKEN_BANG_EQUAL (char->string a (get-char port)) NIL (port-line port))
          (scan port))
    (cons (make-token 'TOKEN_BANG (char->string a) NIL (port-line port))
      (scan port))))

(define (scan-eql port a b)
  (if (char=? b #\=)
    (cons (make-token 'TOKEN_EQUAL_EQUAL (char->string a (get-char port)) NIL (port-line port))
          (scan port))
          
    (cons (make-token 'TOKEN_EQUAL (char->string a) NIL (port-line port))
          (scan port))))

(define (scan-cmp port a b)
  (if (char=? b #\=)
    (error "implement scan-cmp: handle: >= <=")
    (error "implement scan-cmp: handle: <  > ")))

(define (scan-slash port a b)
  (error "Implement scan-slash"))
    

;; the char is from pair char which is member of double or single tokens
(define* (scan-op port #:optional str)
  (let ((a (get-char port))
        (b (lookahead-char port)))
    (cond ((bang? a) (scan-bang port a b)) 
          ((eql? a) (scan-eql port a b))
          ;; > or <
          ((cmp? a) (scan-cmp port a b))
          ((comment? a b) (ignore-line port))
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
           (cond ((eof-object? char) (error "EOF object found scan-string"))
                 ((and (quote-mark? char) str)
                  (cons (make-token 'TOKEN_STRING
                                    (revstr (cons char str))
                                    NIL
                                    (port-line port))
                                   
                        (scan port)))
                 ((and (not (quote-mark? char)) str)
                  (scan-string port (cons char str)))
                 (else (scan-string port (cons char NIL))))))

(define* (scan-number port #:optional digits)
         (let ((char (get-char port)))
           (cond ((eof-object? char) (error "EOF Object Found in scan-number"))
                 ((and (not (digit? char)) digits)
                  (cons (make-token 'TOKEN_NUMBER
                                    (revstr (cons char digits))
                                    NIL
                                    (port-line port))
                        (scan port)))
                 ((and (digit? char) digits)
                  (scan-number port (cons char digits)))
                 (else (scan-number port (cons char NIL))))))

(define (scan port)
 ;; we need to peek here
  (let ((char (lookahead-char port)))
    (cond ((eof-object? char) (cons (make-eof-token port) NIL)) 
          ;; tokens comprising of single char
          ((single-char? char) (cons (make-token (single-char? (get-char port))
                                                 (list->string (list char))
                                                 NIL
                                                 (port-line port))
                                     (scan port)))
          ((double? char) (scan-op port))
          ;; strings?
          ((quote-mark? char) (scan-string port))
          ;; identifier or keyword?
          ((alpha? char) (scan-identifier port))
          ;; whitespace is ignored, consume token and continue
          ((whitespace? char) (begin (get-char port)
                                     (scan port)))
          ((digit? char) (scan-number port))
          (else (cons (make-error-token port) (scan port))))))

(export scan)
