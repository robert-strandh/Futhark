(cl:in-package #:futhark)

(declaim (inline string-upcase-core))

(defun string-upcase-core (string start end)
  (ensure-fresh-string (string)
    (with-canonicalized-and-checked-string ((string start end))
      (for-each-relevant-character (character string start end)
        (setf character (char-upcase character)))
      string)))

(declaim (notinline string-upcase-core))

(declaim (inline string-upcase))

(defun string-upcase (string &key (start 0) end)
  (string-upcase-core string start end))

(declaim (notinline string-upcase))

(define-compiler-macro string-upcase (&whole form &rest arguments)
  (if (one-string-compiler-macro-possible-p arguments)
      (compute-one-string-compiler-macro arguments 'string-upcase-core)
      form))

(setf (documentation 'string-upcase 'function)
      (format nil
              "Syntax: string-upcase string &key start end~@
               ~@
               Return a string which is like STRING, except that each~@
               character in the interval of STRING designated by START~@
               and END is converted to uppercase by a call to~@
               CHAR-UPCASE.~@
               ~@
               ~@
               ~a~@
               ~@
               ~a"
              *start-and-end-are-bounding-index-designators*
              *definition-of-bounding-index-designators*))
