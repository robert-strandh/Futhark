(cl:in-package #:asdf-user)

(defsystem "futhark-intrinsic"
  :serial t
  :components
  ((:file "packages")
   (:file "utilities")
   (:file "string-equal-sign")))
