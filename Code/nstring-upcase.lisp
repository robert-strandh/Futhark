(cl:in-package #:futhark)

(declaim (inline nstring-upcase-core))

(defun nstring-upcase-core (string start end)
  (ensure-string-type string)
  (with-canonicalized-and-checked-string ((string start end))
    (for-each-relevant-character (character string start end)
      (setf character (char-upcase character))))
  string)

(declaim (notinline nstring-upcase-core))

(declaim (inline nstring-upcase))

(defun nstring-upcase (string &key (start 0) end)
  (nstring-upcase-core string start end))

(declaim (notinline nstring-upcase))

(define-compiler-macro nstring-upcase (&whole form &rest arguments)
  (if (one-string-compiler-macro-possible-p arguments)
      (compute-one-string-compiler-macro arguments 'nstring-upcase)
      form))
