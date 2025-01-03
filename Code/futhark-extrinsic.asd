(cl:in-package #:asdf-user)

(defsystem "futhark-extrinsic"
  :serial t
  :components
  ((:file "packages-extrinsic")
   (:file "utilities")
   (:file "compiler-macro-support")
   (:file "documentation-support")
   (:file "string")
   (:file "stringp")
   (:file "make-string")
   (:file "string-equal-sign")
   (:file "string-equal")
   (:file "string-not-equal-sign")
   (:file "string-not-equal")
   (:file "string-less-sign")
   (:file "string-lessp")
   (:file "string-greater-sign")
   (:file "string-greaterp")
   (:file "string-less-or-equal-sign")
   (:file "string-not-greaterp")
   (:file "string-greater-or-equal-sign")
   (:file "string-not-lessp")
   (:file "nstring-upcase")
   (:file "string-upcase")
   (:file "nstring-downcase")
   (:file "string-downcase")
   (:file "nstring-capitalize")
   (:file "string-capitalize")
   (:file "string-left-trim")
   (:file "string-right-trim")
   (:file "string-trim")
   (:file "condition-types")))

(asdf:defsystem "futhark-extrinsic/ansi-test"
  :description "ANSI Test system for Constrictor"
  :license "BSD"
  :author ("Robert Strandh")
  :depends-on ("constrictor-extrinsic"
               "ansi-test-harness")
  :perform (asdf:test-op (op c)
             (uiop:symbol-call :constrictor-extrinsic/ansi-test :test))
  :components ((:module code
                :pathname "ansi-test/"
                :serial t
                :components ((:file "packages")
                             (:file "test")
                             (:static-file "expected-failures.sexp")))))
