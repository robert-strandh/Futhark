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
