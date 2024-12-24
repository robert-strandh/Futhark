(cl:in-package #:asdf-user)

(defsystem "futhark-extrinsic"
  :serial t
  :components
  ((:file "packages-extrinsic")
   (:file "utilities")
   (:file "string-equal-sign")
   (:file "string-equal")))
