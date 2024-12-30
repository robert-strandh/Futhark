(cl:in-package #:futhark-test)

(defvar *tests*
  '("STRING=."))

(defvar *extrinsic-symbols*
  '(futhark:string=))

(defun test (&rest args)
  (let ((system (asdf:find-system :futhark-extrinsic/ansi-test)))
    (apply #'ansi-test-harness:ansi-test
           :directory (merge-pathnames
                       (make-pathname :directory '(:relative
                                                   "dependencies"
                                                   "ansi-test"))
                       (asdf:component-pathname system))
           :expected-failures
           (asdf:component-pathname
            (asdf:find-component system
                                 '("code"
                                   "expected-failures.sexp")))
           :extrinsic-symbols *extrinsic-symbols*
           :tests *tests*
           args)))
