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

(setf (documentation 'string 'function)
      (format nil
              "Syntax: string object~@
               ~@
               If OBJECT is a string, it is returned.  If OBJECT~@
               is a character, then a string containing that character~@
               as its only element is returned.  If OBJECT is a symbol,~@
               return the name of that symbol.  Othewise an error of type~@
               TYPE-ERROR is signaled."))
