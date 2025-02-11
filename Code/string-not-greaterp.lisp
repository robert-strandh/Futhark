(cl:in-package #:futhark)

(declaim (inline string-not-greaterp-core))

(defun string-not-greaterp-core (string1 string2 start1 end1 start2 end2)
  (with-canonicalized-and-checked-strings
      ((string1 start1 end1) (string2 start2 end2))
    (multiple-value-bind (result index)
        (compare-equal string1 start1 end1 string2 start2 end2)
      (ecase result ((< =) index) (> nil)))))

(declaim (notinline string-not-greaterp-core))

(declaim (inline string-not-greaterp))

(defun string-not-greaterp (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (string-not-greaterp-core string1 string2 start1 end1 start2 end2))

(declaim (notinline string-not-greaterp))

(define-compiler-macro string-not-greaterp (&whole form &rest arguments)
  (if (two-string-compiler-macro-possible-p arguments)
      (compute-two-string-compiler-macro
       arguments 'string-not-greaterp-core)
      form))

(setf (documentation 'string-not-greaterp 'function)
      (format nil
              "Syntax: string-not-greaterp string1 string2 &key start1 end1 start2 end2~@
               ~@
               ~a  If the two intervals are equal, then~@
               this function returns the value designated by END1.~@
               The characters are compared using the functions~@
               CHAR-LESSP and CHAR-EQUAL.~@
               ~@
               ~a~@
               ~@
               ~a~@
               ~@
               ~a~@
               ~@
               ~a"
              *a-string-is-less*
              *string1-and-string2-are-string-designators*
              *this-function-calls-the-string-function*
              *start1/2-and-end1/2-are-bounding-index-designators*
              *definition-of-bounding-index-designators*))
