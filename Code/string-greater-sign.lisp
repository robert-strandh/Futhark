(cl:in-package #:futhark)

(declaim (inline string>))

(defun string> (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (with-canonicalized-and-checked-strings
      ((string1 start1 end1) (string2 start2 end2))
    (ecase (compare= string1 start1 end1 string2 start2 end2)
      (> t) ((< =) nil))))

(declaim (notinline string>))
