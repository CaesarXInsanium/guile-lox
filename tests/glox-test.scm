(use-modules (glox)
             (srfi srfi-64))

(test-begin "run-file")
;; this procedure is actually exported!
(test-assert (procedure? run-file))
;; sometimes a path does not exist
(test-error #t (run-file "/banana"))
;; but if a file does not exist, how should the failure be processed?

(test-end "run-file")
