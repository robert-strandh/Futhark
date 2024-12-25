(cl:in-package #:futhark)

(defun make-string (size
                    &key
                      (initial-element #\Space)
                      (element-type 'character))
  (make-array size
              :initial-element initial-element
              :element-type element-type))
