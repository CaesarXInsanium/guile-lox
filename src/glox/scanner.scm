(define-module (glox scanner))
(use-modules (ice-9 textual-ports)
             (glox char)
             (glox tokens))

(define NIL '())

;; the char is from pair char which is member of double or single tokens
(define (scan-op port #:optional str)
  (let ((a (get-char port))
        (b (lookahead-char port)))
    (cond ((bang? a) (scan-bang port a b)) 
          ((eql? a) (scan-eql port a b))
          ;; > or <
          ((eopt? a) (scan-eqlop port a b))
          ((comment? a b) (ignore-line port))
          (else (cons (make-token 'TOKEN_SLASH (char->string a) NIL (port-line))
                      (scan port))))))

;; (define (scan-number port #:key start))

;; simply scan until we hit a newline, space
(define* (scan-identifier port #:optional start str)
  (let ((char (get-char port)))
    (if (and start str)
      (cond ((or (alpha-symbol? char) (alpha-numeric? char)) 
             (scan-identifier port start (cons char str)))
            ;; if it is whitespace, we should exclude the char, put it back
            ((or (single-char? char) (whitespace? char)) 
             (cons (make-token (keyword? (rev-lst-str str))
                         (rev-lst-str str)
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
(define* (scan-string port #:optional start str)
  (let ((char (get-char port)))
    (if (and start str) ;; check if start and str are defined
      (if (quote-mark? char)
        (cons (make-token 'TOKEN_STRING (rev-lst-str (cons char str)) NIL (port-line port))
              (scan port))
        (scan-string port start (cons char str)))
      (scan-string port (port-column port) (list char)))))
    

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
          ;; strings?
          ((quote-mark? char) (scan-string port))
          ((alpha? char) (scan-identifier port))
          ;; whitespace is ignored
          ((whitespace? char) (begin (get-char port)
                                     (scan port)))
          (else (cons (make-error-token port) (scan port))))))

(export scan)
