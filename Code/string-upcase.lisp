(cl:in-package #:futhark)

(declaim (inline string-upcase))

(defun string-upcase (string &key (start 0) end)
  (ensure-fresh-string (string)
    (with-canonicalized-and-checked-string ((string start end))
      (for-each-relevant-character (character string start end)
        (setf character (char-upcase character))))
    string))

(declaim (notinline string-upcase))
