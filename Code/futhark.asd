(cl:in-package #:asdf-user)

(defsystem "futhark"
  :serial t
  :components
  ((:file "packages")
   (:file "utilities")
   (:file "string-equal-sign")))
