(cl:in-package #:futhark-test)

(defvar *tests*
  '("STRING=."
    "STRING-EQUAL."
    "STRING/="
    "STRING-NOT-EQUAL"))

(defvar *extrinsic-symbols*
  '(futhark:string=
    futhark:string-equal
    futhark:string/=
    futhark:string-not-equal))

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
