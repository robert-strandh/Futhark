(cl:in-package #:futhark)

(defgeneric string (object))

(defmethod string ((object cl:string))
  object)

(defmethod string ((object symbol))
  (symbol-name object))

(defmethod string ((object character))
  (make-string 1 :initial-element object))
