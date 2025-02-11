(cl:in-package #:futhark)

(declaim (inline string-not-equal-core))

(defun string-not-equal-core (string1 string2 start1 end1 start2 end2)
  (with-canonicalized-and-checked-strings
      ((string1 start1 end1) (string2 start2 end2))
    (ecase (compare-equal string1 start1 end1 string2 start2 end2)
      (= nil) ((< >) t))))

(declaim (notinline string-not-equal-core))

(declaim (inline string-not-equal))

(defun string-not-equal (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (string-not-equal-core string1 string2 start1 end1 start2 end2))

(declaim (notinline string-not-equal))

(define-compiler-macro string-not-equal (&whole form &rest arguments)
  (if (two-string-compiler-macro-possible-p arguments)
      (compute-two-string-compiler-macro arguments 'string-not-equal-core)
      form))

(setf (documentation 'string-not-equal 'function)
      (format nil
              "Syntax: string-not-equal string1 string2 &key start1 end1 start2 end2~@
               ~@
               ~a CHAR-EQUAL.~@
               ~@
               ~a~@
               ~@
               ~a~@
               ~@
               ~a~@
               ~@
               ~a"
              *if-strings-are-not-equal*
              *string1-and-string2-are-string-designators*
              *this-function-calls-the-string-function*
              *start1/2-and-end1/2-are-bounding-index-designators*
              *definition-of-bounding-index-designators*))
