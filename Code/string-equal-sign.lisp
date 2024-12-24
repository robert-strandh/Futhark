(cl:in-package #:futhark)

(declaim (inline string=))

(defun string= (string1 string2 &key (start1 0) end1 (start2 0) end2)
  (with-canonicalized-and-checked-strings
      ((string1 string1) (start1 start1) (end1 end1)
       (string2 string2) (start2 start2) (end2 end2))
    (ecase (compare= string1 start1 end1 string2 start2 end2)
      (= t) ((< >) nil))))

(declaim (notinline string=))

(setf (documentation 'string= 'function)
      (format nil
              "Syntax: string= string1 string2  &key start1 end1 start2 end2"))
