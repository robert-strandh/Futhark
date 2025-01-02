(cl:in-package #:futhark)

(defgeneric string (object))

(defmethod string (object)
  (error 'type-error
         :datum object
         :expected-type '(or cl:string symbol character)))

(defmethod string ((object cl:string))
  object)

(defmethod string ((object symbol))
  (symbol-name object))

(defmethod string ((object character))
  (make-string 1 :initial-element object))
