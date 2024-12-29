(cl:in-package #:futhark)

(defun string-right-trim (character-bag string-designator)
  (let* ((string (string string-designator))
         (start 0)
         (end (length string)))
    (block b
      (for-each-relevant-character (character string start end :from-end t)
        (if (null (find character character-bag))
            (return-from b)
            (decf end))))
    (extract-interval string start end)))
