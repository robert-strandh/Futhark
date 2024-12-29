(cl:in-package #:futhark)

(declaim (inline string-trim))

(defun string-trim (character-bag string-designator)
  (let* ((string (string string-designator))
         (start 0)
         (end (length string)))
    (block b
      (for-each-relevant-character (character string start end)
        (if (null (find character character-bag))
            (return-from b)
            (incf start))))
    (block b
      (for-each-relevant-character (character string start end :from-end t)
        (if (or (= end start) (null (find character character-bag)))
            (return-from b)
            (decf end))))
    (extract-interval string start end)))

(declaim (notinline string-trim))

(setf (documentation 'string-trim 'function)
      (format nil
              "Syntax: string-trim character-bag string~@
               ~@
               Return a string which is like STRING except that~@
               characters at the beinning and at the end of STRING~@
               that are in CHARACTER-BAG have been removed.~@
               ~@
               CHARACTER-BAG is a sequence containing characters.~@
               ~@
               This function always returns a fresh string."))
