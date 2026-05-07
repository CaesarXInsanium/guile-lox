;; COMENTARY
(define-module (glox)
               #:use-module (glox scanner)
               #:use-module (glox error)
               #:use-module (glox utils)
               #:use-module (glox parser)
               #:use-module (ice-9 textual-ports)
               #:use-module (ice-9 readline)
               #:export (run-file))

(define stdin (current-input-port))
(define stdout (current-output-port))


;; Takes a file path, loads the file and evaluates it.
;; this can fail
;; reasons for failure
;; path-does-not-exist, not a file, no permission, not enough ram
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
  (define tokens (with-exception-handler lexer-exception-handler 
                                         (lambda () (scan source))
                                         #:unwind? #t
                                         #:unwind-for-type &lox-error))
  (display tokens)
  (newline))
  
(define prompt "> ")

;; TODO command history
;; TODO figure out how much this shit sucks ass
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
;; TODO handle C-d and C-c keyboard interrupts
(define (glox-main args)
;; entry point
  (display args)
  (newline)
  (if (< 1 (length args))
    ;; assumes that the argument given is a valid path
    (run-file (list-ref args 1))
    (run-repl)))

(export glox-main
        run-file)
