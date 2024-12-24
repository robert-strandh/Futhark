(cl:in-package #:futhark)

(declaim (inline string-not-equal))

(defun string-not-equal (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (with-canonicalized-and-checked-strings
      ((string1 string1) (start1 start1) (end1 end1)
       (string2 string2) (start2 start2) (end2 end2))
    (ecase (compare-equal string1 start1 end1 string2 start2 end2)
      (= nil) ((< >) t))))

(declaim (notinline string-not-equal))
