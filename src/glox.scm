;; COMENTARY
(define-module (glox))

(use-modules (ice-9 textual-ports))

(use-modules (glox scanner))

(define STDIN (current-input-port))
(define STDOUT (current-output-port))


;; Takes a file path, loads the file and evaluates it.
(define (run-file path)
  "Docs"
  (format STDOUT "Running File: ~s~%" path)
  (define port (open path O_RDONLY))
  (let ((source (get-string-all port)))
    (run (open-input-string source))))

;; source is a port
(define (run source)
  (format STDOUT "running source~%")
  (let ((tokens (scan source)))
    (format STDOUT "Tokens:~%~s" tokens)))

;; arguments, there is always at least one argument
(define (glox-main args)
;; entry point
  (display args)
  (newline)
  (if (< 1 (length args))
    (run-file (list-ref args 1))
    (run (open-input-string (get-line STDIN)))))

(export glox-main)
