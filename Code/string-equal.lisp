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

(setf (documentation 'string-equal 'function)
      (format nil
              "Syntax: string-equal string1 string2 &key start1 end1 start2 end2~@
               ~@
               Return T if the designated intervals of the two~@
               strings are equal.  Return NIL otherwise.~@
               Comparison is done using the function CHAR-EQUAL.~@
               ~@
               ~a~@
               ~@
               ~a~@
               ~@
               ~a~@
               ~@
               ~a"
              *string1-and-string2-are-string-designators*
              *this-function-calls-the-string-function*
              *start1/2-and-end1/2-are-bounding-index-designators*
              *definition-of-bounding-index-designators*))
