;; COMENTARY
(define-module (glox))

(use-modules (ice-9 textual-ports))

(define STDIN (current-input-port))
(define STDOUT (current-output-port))


;; Takes a file path, loads the file and evaluates it.
(define (run-file path)
  "Docs"
  (format STDOUT "Running File: ~s~%" path)
  (with-input-from-file path
                        (let ((source (get-string-all)))
                          (run source))))

(define (run source)
  (format STDOUT "running source~%"))

(define (glox-main args)
;; entry point
  (display args))

(export glox-main)
