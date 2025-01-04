(cl:in-package #:futhark)

(declaim (inline string-capitalize))

(defun string-capitalize-core (string start end)
  (ensure-fresh-string (string)
    (let ((state nil)) 
      (with-canonicalized-and-checked-string ((string start end))
        (for-each-relevant-character (character string start end)
          (if state
              (if (alphanumericp character)
                  (setf character (char-downcase character))
                  (setf state nil))
              (when (alphanumericp character)
                (setf character (char-upcase character))
                (setf state t))))
        string))))

(declaim (notinline string-capitalize))

(declaim (inline string-capitalize))

(defun string-capitalize (string &key (start 0) (end nil))
  (string-capitalize-core string start end))

(declaim (notinline string-capitalize))

(define-compiler-macro string-capitalize (&whole form &rest arguments)
  (if (one-string-compiler-macro-possible-p arguments)
      (compute-one-string-compiler-macro arguments 'string-capitalize-core)
      form))
