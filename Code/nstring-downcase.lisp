(cl:in-package #:futhark)

(declaim (inline nstring-downcase-core))

(defun nstring-downcase-core (string start end)
  (ensure-string-type string)
  (with-canonicalized-and-checked-string ((string start end))
    (for-each-relevant-character (character string start end)
      (setf character (char-downcase character))))
  string)

(declaim (notinline nstring-downcase-core))

(declaim (inline nstring-downcase))

(defun nstring-downcase (string &key (start 0) end)
  (nstring-downcase-core string start end))

(declaim (notinline nstring-downcase))

(define-compiler-macro nstring-downcase (&whole form &rest arguments)
  (if (one-string-compiler-macro-possible-p arguments)
      (compute-one-string-compiler-macro arguments 'nstring-downcase-core)
      form))

(setf (documentation 'nstring-downcase 'function)
      (format nil
              "Syntax: nstring-downcase string &key start end~@
               ~@
               Each character in the interval of STRING designated by~@
               START and END is converted to lowercase by a call to~@
               CHAR-DOWNCASE.~@
               ~@
               If STRING is not a string, an error of type TYPE-ERROR~@
               is signaled.~@
               ~@
               ~a~@
               ~@
               ~a"
              *start-and-end-are-bounding-index-designators*
              *definition-of-bounding-index-designators*))
