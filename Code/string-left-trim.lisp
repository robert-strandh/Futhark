(cl:in-package #:futhark)

(declaim (inline string-left-trim))

(defun string-left-trim (character-bag string-designator)
  (let* ((string (string string-designator))
         (start 0)
         (end (length string)))
    (block b
      (for-each-relevant-character (character string start end)
        (if (null (find character character-bag))
            (return-from b)
            (incf start))))
    (subseq string start end)))

(declaim (notinline string-left-trim))

(setf (documentation 'string-left-trim 'function)
      (format nil
              "Syntax: string-left-trim character-bag string~@
               ~@
               Return a string which is like STRING except that~@
               characters at the beinning of STRING that are in~@
               CHARACTER-BAG have been removed.~@
               ~@
               CHARACTER-BAG is a sequence containing characters.~@
               ~@
               This function always returns a fresh string."))
