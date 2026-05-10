;; COMENTARY
(define-module (glox)
               #:use-module (glox scanner)
               #:use-module (glox error)
               #:use-module (glox utils)
               #:use-module (glox parser)
               #:use-module (ice-9 textual-ports)
               #:use-module (ice-9 readline)
               #:export (run-file glox-main))

(define stdin (current-input-port))
(define stdout (current-output-port))

(define (run-file path)
  "Docs"
  (format stdout "Running File: ~s~%" (canonicalize-path path))
  (let* ((port (open path O_RDONLY))
         (source (get-string-all port)))
    (run (open-input-string source))))

;; source is a port
;; This function will have to be updated when work on parser commences
;; TODO this code sucks ass
(define (run source)
  (for-each 
    (lambda (x) 
      (format #t "~s~%" x))
    (with-exception-handler lexer-exception-handler 
                          (lambda () (scan source))
                          #:unwind? #t
                          #:unwind-for-type &lox-error)))
  
(define prompt "> ")

;; TODO command history
;; TODO figure out how much this shit sucks ass
;; TODO how does this code get replaced or configured to store state over time?
;; TODO handle C-d and C-c keyboard interrupts
(define (run-repl)
  ;; activate-readline is very useful when inputing code into a REPL
  ;; use the @ syntax to minimize import clutter
  (activate-readline)
  (define previous NIL)
  (let loop ((user-input (readline prompt)))
    ;; TODO handle cases where user inputs certain Key Sequences
    (begin (run (open-input-string (if (eof-object? user-input)
                                     (exit) user-input)))
           (set! previous user-input)
           (loop (readline prompt)))))

;; arguments, there is always at least one argument
;; TODO better argument processing
(define (glox-main args)
  (if (< 1 (length args))
    ;; assumes that the argument given is a valid path
    (if (file-exists? (list-ref args 1))
      (run-file (list-ref args 1))
      (error "File does not exists!"))
    (run-repl)))
