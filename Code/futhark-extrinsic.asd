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
   (:file "string-greater-sign")))
