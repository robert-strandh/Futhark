(cl:in-package #:futhark)

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
