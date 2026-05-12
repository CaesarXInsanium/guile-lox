(use-modules (glox)
             (glox utils)
             (srfi srfi-64))
(format #t "test-log-to-file: ~s~%" test-log-to-file)
(set! test-log-to-file #f)

(test-begin "chunks")
(test-eq 1 1)
(test-end "chunks")
