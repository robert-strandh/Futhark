(cl:in-package #:futhark)

(declaim (inline string-lessp-core))

(defun string-lessp-core (string1 string2 start1 end1 start2 end2)
  (with-canonicalized-and-checked-strings
      ((string1 start1 end1) (string2 start2 end2))
    (multiple-value-bind (result index)
        (compare-equal string1 start1 end1 string2 start2 end2)
      (ecase result (< index) ((> =) nil)))))

(declaim (notinline string-lessp-core))

(declaim (inline string-lessp))

(defun string-lessp (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (string-lessp-core string1 string2 start1 end1 start2 end2))

(declaim (notinline string-lessp))

(define-compiler-macro string-lessp (&whole form &rest arguments)
  (if (two-string-compiler-macro-possible-p arguments)
      (compute-two-string-compiler-macro arguments 'string-lessp-core)
      form))

(setf (documentation 'string-lessp 'function)
      (format nil
              "Syntax: string-lessp string1 string2 &key start1 end1 start2 end2~@
               ~@
               A string A is less than a string B if in the first~@
               position in which they differ, the character of A~@
               is less than the corresponding character of B, or~@
               if A is a proper prefix of B.  If the interval of~@
               STRING1 designated by START1 and END1 is less than~@
               the interval of STRING2 designated by START2 and END2~@
               according to this definition, then this function returns~@
               the index of the first position at which the two~@
               intervals differ, as a an offset from the start of~@
               STRING1.  Otherwise, this function returns NIL.~@
               The characters are compared using the function~@
               CHAR-LESSP.
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
