;; COMENTARY
(define-module (glox)
               #:use-module (glox scanner)
               #:use-module (glox utils)
               #:use-module (glox parser)
               #:use-module (glox panic)
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
    (scan source)))
  
(define prompt "> ")

;; TODO command history
;; TODO figure out how much this shit sucks ass
;; TODO how does this code get replaced or configured to store state over time?
;; TODO handle C-d and C-c keyboard interrupts
(define (run-repl)
  ;; activate-readline is very useful when inputing code into a REPL
  ;; use the @ syntax to minimize import clutter
  (activate-readline)
  (define history NIL)
  (let loop ((user-input (readline prompt)))
    ;; TODO handle cases where user inputs certain Key Sequences
    (begin (run (open-input-string (if (eof-object? user-input)
                                     (exit) user-input)))
           (set! history (cons user-input history))
           (loop (readline prompt)))))

;; arguments, there is always at least one argument
;; TODO better argument processing
(define (glox-main args)
  (if (< 1 (length args))
    ;; assumes that the argument given is a valid path
    (let ((maybe-path (list-ref args 1)))
      (if (file-exists? maybe-path)
          (run-file maybe-path)
          (panic! 'glox-main "File does not exist!" maybe-path)))
    (run-repl)))
