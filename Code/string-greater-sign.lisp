(cl:in-package #:futhark)

(declaim (inline string>-core))

(defun string>-core (string1 string2 start1 end1 start2 end2)
  (with-canonicalized-and-checked-strings
      ((string1 start1 end1) (string2 start2 end2))
    (multiple-value-bind (result index)
        (compare= string1 start1 end1 string2 start2 end2)
    (ecase result (> index) ((< =) nil)))))

(declaim (notinline string>-core))

(declaim (inline string>))

(defun string> (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (string>-core string1 string2 start1 end1 start2 end2))

(declaim (notinline string>))
