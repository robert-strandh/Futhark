(cl:in-package #:futhark)

(declaim (inline nstring-capitalize-core))

(defun nstring-capitalize-core (string start end)
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

(declaim (inline nstring-capitalize-core))

(defun nstring-capitalize (string &key (start 0) (end nil))
  (nstring-capitalize-core string start end))

(declaim (notinline nstring-capitalize))

(define-compiler-macro nstring-capitalize (&whole form &rest arguments)
  (if (one-string-compiler-macro-possible-p arguments)
      (compute-one-string-compiler-macro arguments 'nstring-capitalize)
      form))
