(cl:in-package #:futhark)

(defgeneric stringp (object))

(defmethod stringp (object)
  (declare (ignorable object))
  nil)

(defmethod stringp ((object cl:string))
  (declare (ignorable object))
  t)

(setf (documentation 'stringp 'function)
      (format nil
              "Syntax: stringp object~@
               ~@
               If OBJECT is a string, then return T.  Otherwise,~@
               return NIL."))
