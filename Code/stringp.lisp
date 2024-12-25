(cl:in-package #:futhark)

(defgeneric stringp (object))

(defmethod stringp (object)
  (declare (ignorable object))
  nil)

(defmethod stringp ((object cl:string))
  (declare (ignorable object))
  t)
