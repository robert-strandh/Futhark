(cl:in-package #:futhark)

(defun string-left-trim (character-bag string-designator)
  (let* ((string (string string-designator))
         (start 0)
         (end (length string)))
    (block b
      (for-each-relevant-character (character string start end)
        (if (null (find character character-bag))
            (return-from b)
            (incf start))))
    (extract-interval string start end)))
