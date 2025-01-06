(cl:in-package #:futhark)

(declaim (inline make-string-core))

(defun make-string-core (size initial-element element-type)
  (make-array size
              :initial-element initial-element
              :element-type element-type))

(declaim (notinline make-string-core))

(declaim (inline make-string))

(defun make-string (size
                    &key
                      (initial-element #\Space)
                      (element-type 'character))
  (make-string-core size initial-element element-type))

(declaim (notinline make-string))

(defun make-string-compiler-macro-possible-p (arguments)
  (and
   ;; There must be at least one argument.
   (>= (length arguments) 1)
   ;; There must be one required argument and an even number of
   ;; keyword arguments, so there must be an odd number of arguments.
   (oddp (length arguments))
   ;; Each keyword must be one of the ones allowed.
   (all-allowed-keywords-p (rest arguments)
                           '(:initial-element :element-type))))

(defun compute-make-string-compiler-macro (arguments)
  (let ((bindings '())
        (remaining arguments))
    (push `(string ,(pop remaining)) bindings)
    (multiple-value-bind (keyword-bindings ignores)
        (make-keyword-bindings remaining)
      (setf bindings (append keyword-bindings bindings))
      `(let ((initial-element #\Space) (element-type 'character))
         (declare (ignorable initial-element element-type))
         (let ,(reverse bindings)
           (declare (ignore ,@ignores))
           (make-string string start end))))))

(define-compiler-macro make-string (&whole form &rest arguments)
  (if (make-string-compiler-macro-possible-p arguments)
      (compute-make-string-compiler-macro arguments)
      form))

(setf (documentation 'make-string 'function)
      (format nil
              "Syntax: make-string size &key initial-element element-type~@
               ~@
               Return a simple string with SIZE instances of INITIAL-ELEMENT~@
               in it.  The default value of INITIAL-ELEMENT is #\Space.~@
               The default value of ELEMENT-TYPE is CHARACTER.  This function~@
               calls MAKE-ARRAY with SIZE and the keyword arguments~@
               INITIAL-ELEMENT and ELEMENT-TYPE."))
