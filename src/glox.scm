;; COMENTARY
(define-module (glox))

(use-modules (ice-9 textual-ports)
             (ice-9 readline))

(use-modules (glox scanner)
             (glox error)
             (glox utils))

(define STDIN (current-input-port))
(define STDOUT (current-output-port))


;; Takes a file path, loads the file and evaluates it.
(define (run-file path)
  "Docs"
  (format STDOUT "Running File: ~s~%" (canonicalize-path path))
  (let* ((port (open path O_RDONLY))
         (source (get-string-all port)))
    (run (open-input-string source))))

;; source is a port
;; This function will have to be updated when work on parser commences
(define (run source)
  (define tokens (with-exception-handler lexer-exception-handler 
                                         (lambda () (scan source))
                                         #:unwind? #t
                                         #:unwind-for-type &lox-error))
  (display tokens)
  (newline))
  
(define prompt "> ")

;; TODO command history
(define (run-repl)
  ;; activate-readline is very useful when inputing code into a REPL
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
;; entry point
  (display args)
  (newline)
  (if (< 1 (length args))
    ;; assumes that the argument given is a valid path
    (run-file (list-ref args 1))
    (run-repl)))

(export glox-main
        run-file)
