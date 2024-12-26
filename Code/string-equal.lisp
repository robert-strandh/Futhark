(cl:in-package #:futhark)

(declaim (inline string-equal-core))

(defun string-equal-core (string1 string2 start1 end1 start2 end2)
  (with-canonicalized-and-checked-strings
      ((string1 start1 end1) (string2 start2 end2))
    (ecase (compare-equal string1 start1 end1 string2 start2 end2)
      (= t) ((< >) nil))))

(declaim (notinline string-equal-core))

(declaim (inline string-equal))

(defun string-equal (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (string-equal-core string1 string2 start1 end1 start2 end2))

(declaim (notinline string-equal))

(define-compiler-macro string-equal (&whole form &rest arguments)
  (if (two-string-compiler-macro-possible-p arguments)
      (compute-two-string-compiler-macro arguments 'string-equal-core)
      form))
