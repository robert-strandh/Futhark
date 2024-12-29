(cl:in-package #:futhark)

(declaim (inline string-greaterp-core))

(defun string-greaterp-core (string1 string2 start1 end1 start2 end2)
  (with-canonicalized-and-checked-strings
      ((string1 start1 end1) (string2 start2 end2))
    (multiple-value-bind (result index)
        (compare-equal string1 start1 end1 string2 start2 end2)
    (ecase result (> index) ((< =) nil)))))

(declaim (notinline string-greaterp-core))

(declaim (inline string-greaterp))

(defun string-greaterp (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (string-greaterp-core string1 string2 start1 end1 start2 end2))

(declaim (notinline string-greaterp))

(define-compiler-macro string-greaterp (&whole form &rest arguments)
  (if (two-string-compiler-macro-possible-p arguments)
      (compute-two-string-compiler-macro arguments 'string-greaterp-core)
      form))

(setf (documentation 'string-greaterp 'function)
      (format nil
              "Syntax: string-greaterp string1 string2 &key start1 end1 start2 end2~@
               ~@
               ~a  Otherwise, this function returns NIL.~@
               The characters are compared using the function~@
               CHAR-GREATERP.
               ~@
               ~a~@
               ~@
               ~a~@
               ~@
               ~a~@
               ~@
               ~a"
              *a-string-is-greater*
              *string1-and-string2-are-string-designators*
              *this-function-calls-the-string-function*
              *start1/2-and-end1/2-are-bounding-index-designators*
              *definition-of-bounding-index-designators*))
