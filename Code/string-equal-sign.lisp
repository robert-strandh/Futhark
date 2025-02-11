(cl:in-package #:futhark)

(declaim (inline string=-core))

(defun string=-core (string1 string2 start1 end1 start2 end2)
  (with-canonicalized-and-checked-strings
      ((string1 start1 end1) (string2 start2 end2))
    (ecase (compare= string1 start1 end1 string2 start2 end2)
      (= t) ((< >) nil))))

(declaim (notinline string=-core))

(declaim (inline string=))

(defun string= (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (string=-core string1 string2 start1 end1 start2 end2))

(declaim (notinline string=))

(define-compiler-macro string= (&whole form &rest arguments)
  (if (two-string-compiler-macro-possible-p arguments)
      (compute-two-string-compiler-macro arguments 'string=-core)
      form))

(setf (documentation 'string= 'function)
      (format nil
              "Syntax: string= string1 string2 &key start1 end1 start2 end2~@
               ~@
               Return T if the designated intervals of the two~@
               strings are equal.  Return NIL otherwise.~@
               Comparison is done using the function CHAR-=.~@
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
