(cl:in-package #:futhark)

(declaim (inline nstring-capitalize))

(defun nstring-capitalize (string &key (start 0) (end nil))
  (ensure-string-type string)
  (let ((state nil))
    (with-canonicalized-and-checked-string ((string start end))
      (for-each-relevant-character (character string start end)
        (if state
            (if (alphanumericp character)
                (setf character (char-downcase character))
                (setf state nil))
            (when (alphanumericp character)
              (setf character (char-upcase character))
              (setf state t))))))
  string)

(declaim (notinline nstring-capitalize))
