;; COMENTARY
(define-module (glox))

(use-modules (ice-9 textual-ports)
             (ice-9 readline))

(use-modules (glox scanner)
             (glox error))

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
(define (run source)
  (define tokens 
    (with-exception-handler lexer-exception-handler 
                            (lambda ()
                              (scan source))
                            #:unwind? #t
                            #:unwind-for-type &lox-lexer-error))
  (display tokens)
  (newline))
  
(define prompt "> ")

(define (run-repl)
  (activate-readline)
  (let loop ((user-input (readline prompt)))
    (begin (run (open-input-string (if (eof-object? user-input)
                                     (exit) user-input)))
           (loop (readline prompt)))))

;; arguments, there is always at least one argument
;; TODO  sdasd
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
