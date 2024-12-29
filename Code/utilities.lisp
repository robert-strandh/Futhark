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
            (return (if (= index2 end2)
                        (values '= nil)
                        (values '< index1)))
          1-not-end
            (unless (= index2 end2)
              (go neither-end))
            (return (if (= index1 end1)
                        (values '= nil)
                        (values '> index1)))
          neither-end
            (cond ((,equal-predicate-name
                    (char string1 index1) (char string2 index2))
                   (incf index1)
                   (incf index2)
                   (go again))
                  ((,less-predicate-name
                    (char string1 index1) (char string2 index2))
                   (return (values '< index1)))
                  (t
                   (return (values '> index1)))))))))

(defun compare-equal (string1 start1 end1 string2 start2 end2)
  (compare-body equal))

(defun compare= (string1 start1 end1 string2 start2 end2)
  (compare-body =))

(defun string-designator-to-fresh-string (string-designator)
  (let ((string (string string-designator)))
    (if (characterp string-designator)
        ;; The string is already freshly allocated, so there
        ;; is no need to copy it again.
        string
        (subseq string 0 (length string)))))

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

(defmacro with-canonicalized-and-checked-strings
    (((string1-var start1-var end1-var)
      (string2-var start2-var end2-var))
     &body body)
  `(let ((,string1-var (string ,string1-var))
         (,end1-var (if (null ,end1-var)
                        (length ,string1-var)
                        ,end1-var))
         (,string2-var (string ,string2-var))
         (,end2-var (if (null ,end2-var)
                        (length ,string2-var)
                        ,end2-var)))
     (check-bounding-indices ,string1-var ,start1-var ,end1-var)
     (check-bounding-indices ,string2-var ,start2-var ,end2-var)
     ,@body))

(defmacro with-canonicalized-and-checked-string
    (((string1-var start1-var end1-var))
     &body body)
  `(let ((,string1-var (string ,string1-var))
         (,end1-var (if (null ,end1-var)
                        (length ,string1-var)
                        ,end1-var)))
     (check-bounding-indices ,string1-var ,start1-var ,end1-var)
     ,@body))

(defun ensure-string-type (string-designator)
  (check-type string-designator cl:string))

(defmacro ensure-fresh-string ((string-var) &body body)
  `(let ((,string-var
           (if (stringp ,string-var) (copy-seq ,string-var) ,string-var)))
     ,@body))
