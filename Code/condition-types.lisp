(cl:in-package #:futhark)

(define-condition bag-is-dotted-list
    (type-error)
  ()
  (:report
   (lambda (condition stream)
     (format stream
             "If a character bag is a list,~@
              it must be a proper list.~@
              But the following dotted list was found instead:~@
              ~s."
             (type-error-datum condition)))))

(define-condition bag-is-circular-list (type-error)
  ()
  (:report
   (lambda (condition stream)
     (format stream
             "If a character bag is a list,~@
              it must be a proper list.~@
              But the following circular list was found instead:~@
              ~s."
             (type-error-datum condition)))))

(define-condition bag-contains-non-character (type-error)
  ()
  (:report
   (lambda (condition stream)
     (format stream
             "A character bag must be a sequence~@
              that contains only characters.~@
              But the following element was found~@
              which is not a character:~@
              ~s."
             (type-error-datum condition)))))

(define-condition invalid-bounding-indices (error)
  ((%target :initarg :target :reader target)
   (%start :initarg start :reader start)
   (%end :initarg end :reader end))
  (:report
   (lambda (condition stream)
     (format stream
             "In order for START and END to be valid bounding indices,~@
              START must between 0 and the length of the string, and~@
              END must be between 0 and the length of the string or NIL,~@
              and START must be less than or equal to END.~@
              But the following values of START and END were found:~@
              ~s, ~s~@
              For the string:~@
              ~s~@
              And the length of that string is ~s."
             (start condition)
             (end condition)
             (target condition)
             (length (target condition))))))
