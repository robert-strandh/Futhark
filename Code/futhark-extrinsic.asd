(cl:in-package #:asdf-user)

(defsystem "futhark-extrinsic"
  :serial t
  :components
  ((:file "packages-extrinsic")
   (:file "utilities")
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
   (:file "string-greater-or-equal-sign")))
