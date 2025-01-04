(cl:in-package #:futhark-test)

(defvar *tests*
  '("STRINGP."
    "MAKE-STRING."
    "STRING=."
    "STRING-EQUAL."
    "STRING/=."
    "STRING-NOT-EQUAL."
    "STRING<."
    "STRING-LESSP."
    "STRING>."
    "STRING-GREATERP."
    "STRING<=."
    "STRING-NOT-GREATERP."
    "STRING>=."
    "STRING-NOT-LESSP."
    "NSTRING-UPCASE."
    "STRING-UPCASE."
    "NSTRING-DOWNCASE."
    "STRING-DOWNCASE."
    "NSTRING-CAPITALIZE."
    "STRING-CAPITALIZE."
    "STRING-LEFT-TRIM."
    "STRING-RIGHT-TRIM."
    "STRING-TRIM."))

(defvar *extrinsic-symbols*
  '(futhark:stringp
    futhark:make-string
    futhark:string=
    futhark:string-equal
    futhark:string/=
    futhark:string-not-equal
    futhark:string<
    futhark:string-lessp
    futhark:string>
    futhark:string-greaterp
    futhark:string<=
    futhark:string-not-greaterp
    futhark:string>=
    futhark:string-not-lessp
    futhark:nstring-upcase
    futhark:string-upcase
    futhark:nstring-downcase
    futhark:string-downcase
    futhark:nstring-capitalize
    futhark:string-capitalize
    futhark:string-left-trim
    futhark:string-right-trim
    futhark:string-trim))

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
