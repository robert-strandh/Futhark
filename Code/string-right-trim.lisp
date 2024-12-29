(cl:in-package #:futhark)

(declaim (inline string-right-trim))

(defun string-right-trim (character-bag string-designator)
  (let* ((string (string string-designator))
         (start 0)
         (end (length string)))
    (block b
      (for-each-relevant-character (character string start end :from-end t)
        (if (null (find character character-bag))
            (return-from b)
            (decf end))))
    (subseq string start end)))

(declaim (notinline string-right-trim))

(setf (documentation 'string-right-trim 'function)
      (format nil
              "Syntax: string-right-trim character-bag string~@
               ~@
               Return a string which is like STRING except that~@
               characters at the end of STRING that are in~@
               CHARACTER-BAG have been removed.~@
               ~@
               CHARACTER-BAG is a sequence containing characters.~@
               ~@
               This function always returns a fresh string."))
