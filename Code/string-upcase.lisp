(cl:in-package #:futhark)

(declaim (inline string-upcase-core))

(defun string-upcase-core (string start end)
  (ensure-fresh-string (string)
    (with-canonicalized-and-checked-string ((string start end))
      (for-each-relevant-character (character string start end)
        (setf character (char-upcase character))))
    string))

(declaim (notinline string-upcase-core))

(declaim (inline string-upcase))

(defun string-upcase (string &key (start 0) end)
  (string-upcase-core string start end))

(declaim (notinline string-upcase))

(define-compiler-macro string-upcase (&whole form &rest arguments)
  (if (one-string-compiler-macro-possible-p arguments)
      (compute-one-string-compiler-macro arguments 'string-upcase)
      form))
