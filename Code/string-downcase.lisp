(cl:in-package #:futhark)

(declaim (inline string-downcase-core))

(defun string-downcase-core (string start end)
  (ensure-fresh-string (string)
    (with-canonicalized-and-checked-string ((string start end))
      (for-each-relevant-character (character string start end)
        (setf character (char-downcase character)))
      string)))

(declaim (notinline string-downcase-core))

(declaim (inline string-downcase))

(defun string-downcase (string &key (start 0) end)
  (string-downcase-core string start end))

(declaim (notinline string-downcase))

(define-compiler-macro string-downcase (&whole form &rest arguments)
  (if (one-string-compiler-macro-possible-p arguments)
      (compute-one-string-compiler-macro arguments 'string-downcase-core)
      form))
