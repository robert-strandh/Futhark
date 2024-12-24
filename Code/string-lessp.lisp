(cl:in-package #:futhark)

(declaim (inline string-lessp))

(defun string-lessp (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (with-canonicalized-and-checked-strings
      ((string1 start1 end1) (string2 start2 end2))
    (ecase (compare-equal string1 start1 end1 string2 start2 end2)
      (< t) ((> =) nil))))

(declaim (notinline string-lessp))