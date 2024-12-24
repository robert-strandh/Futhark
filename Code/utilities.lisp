(cl:in-package #:futhark)

(defmacro compare-body (name)
  (multiple-value-bind (less-predicate-name equal-predicate-name)
      (if (eq name '=)
          (values 'char< 'char=)
          (values 'char-lessp 'char-equal))
    `(let ((index1 start1)
           (index2 start2))
       (block nil
         (tagbody
          again
            (unless (= index1 end1)
              (go 1-not-end))
            (return (if (= index2 end2) '= '<))
          1-not-end
            (unless (= index2 end2)
              (go neither-end))
            (return (if (= index1 end1) '= '>))
          neither-end
            (cond ((,equal-predicate-name
                    (char string1 index1) (char string2 index2))
                   (incf index1)
                   (incf index2)
                   (go again))
                  ((,less-predicate-name
                    (char string1 index1) (char string2 index2))
                   (return '<))
                  (t
                   (return '>))))))))

;;; Create a fresh string containing the characters of STRING in the
;;; interval between START and END.
(defun extract-interval (string start end)
  (let ((result (make-string (- end start))))
    (loop for source-index from start below end
          for destination-index from 0
          do (setf (char result destination-index)
                   (char string source-index)))
    result))

(defun string-designator-to-fresh-string (string-designator)
  (let ((string (string string-designator)))
    (if (characterp string-designator)
        ;; The string is already freshly allocated, so there
        ;; is no need to copy it again.
        string
        (extract-interval string 0 (length string)))))

(defmacro for-each-relevant-character
    ((character-var string-form start-form end-form &key from-end) &body body)
  (let ((string-var (gensym))
        (index-var (gensym)))
    `(let ((,string-var ,string-form))
       (symbol-macrolet ((,character-var (char ,string-var ,index-var)))
         ,(if from-end
              `(loop for ,index-var downfrom (1- ,end-form) to ,start-form
                     do ,@body)
              `(loop for ,index-var from ,start-form below ,end-form
                     do ,@body))))))

(defun check-bounding-indices (string start end)
  (let ((length (length string)))
    (unless (typep start `(integer 0 ,length))
      (error 'type-error
             :datum start
             :expected-type `(integer 0 ,length)))
    (unless (typep end `(integer 0 ,length))
      (error 'type-error
             :datum end
             :expected-type `(integer 0 ,length)))
    (unless (<= start end)
      (error 'invalid-bounding-indices
             :start start
             :end end
             :target string))))

(defmacro with-checked-bounding-indices
    (((string-var string-form)
      (start-var start-form)
      (end-var end-form))
     &body body)
  (let ((length-var (gensym)))
    `(let ((,string-var ,string-form)
           (,start-var ,start-form)
           (,end-var ,end-form))
       (let ((,length-var (length ,string-var)))
         (unless (typep ,start-var `(integer 0 ,,length-var))
           (error 'type-error
                  :datum ,start-var
                  :expected-type `(integer 0 ,,length-var)))
         (unless (typep ,end-var `(or null (integer 0 ,,length-var)))
           (error 'type-error
                  :datum ,end-var
                  :expected-type `(or null (integer 0 ,,length-var))))
         (when (null ,end-var)
           (setq ,end-var ,length-var))
         (unless (<= ,start-var ,end-var)
           (error 'invalid-bounding-indices
                  :start ,start-var
                  :end ,end-var
                  :target ,string-var))
         ,@body))))

(defmacro with-canonicalized-and-checked-strings
    (((string1-var string1-form)
      (start1-var start1-form)
      (end1-var end1-form)
      (string2-var string2-form)
      (start2-var start2-form)
      (end2-var end2-form))
     &body body)
  `(let ((,string1-var (string ,string1-form))
         (,start1-var ,start1-form)
         (,end1-var ,end1-form)
         (,string2-var (string ,string2-form))
         (,start2-var ,start2-form)
         (,end2-var ,end2-form))
     (with-checked-bounding-indices
         ((,string1-var ,string1-var)
          (,start1-var ,start1-var)
          (,end1-var ,end1-var)))
       (with-checked-bounding-indices
           ((,string2-var ,string2-var)
            (,start2-var ,start2-var)
            (,end2-var ,end2-var))
         ,@body)))
