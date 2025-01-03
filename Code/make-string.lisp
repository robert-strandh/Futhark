(cl:in-package #:futhark)

(defun make-string (size
                    &key
                      (initial-element #\Space)
                      (element-type 'character))
  (make-array size
              :initial-element initial-element
              :element-type element-type))

(setf (documentation 'make-string 'function)
      (format nil
              "Syntax: make-string size &key initial-element element-type~@
               ~@
               Return a simple string with SIZE instances of INITIAL-ELEMENT~@
               in it.  The default value of INITIAL-ELEMENT is #\Space.~@
               The default value of ELEMENT-TYPE is CHARACTER.  This function~@
               calls MAKE-ARRAY with SIZE and the keyword arguments~@
               INITIAL-ELEMENT and ELEMENT-TYPE."))
