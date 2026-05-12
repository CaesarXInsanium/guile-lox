(use-modules (glox panic)
             (srfi srfi-64))

(test-begin "panic")
(test-error (panic! 'testing "hi! this is a test!"))
(test-error (panic! 'testing "hi! this is a test!" 'weird-data))
(test-end "panic")

(test-begin "todo")
(test-error (todo! 'todo))
(test-error (todo! 'todo 'a))
(test-error (todo! 'todo 'a 'b))
(test-end "todo")

(test-begin "unreachable")
(test-error (unreachable! 'a 1 2 3))
(test-end "unreachable")
