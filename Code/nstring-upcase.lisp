(cl:in-package #:futhark)

(declaim (inline nstring-upcase))

(defun nstring-upcase (string &key (start 0) end)
  (ensure-string-type string)
  (with-canonicalized-and-checked-string ((string start end))
    (for-each-relevant-character (character string start end)
      (setf character (char-upcase character))))
  string)

(declaim (notinline nstring-upcase))
