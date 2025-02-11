(cl:in-package #:futhark)

(defun all-allowed-keywords-p (keyword-arguments keywords)
  (loop for keyword in keyword-arguments by #'cddr
        always (member keyword keywords :test #'eq)))

(defun one-string-compiler-macro-possible-p (arguments)
  (and
   ;; There must be at least one argument.
   (>= (length arguments) 1)
   ;; There must be one required argument and an even number of
   ;; keyword arguments, so there must be an odd number of arguments.
   (oddp (length arguments))
   ;; Each keyword must be one of the ones allowed.
   (all-allowed-keywords-p (rest arguments) '(:start :end))))

(defun two-string-compiler-macro-possible-p (arguments)
  (and
   ;; There must be at least two arguments.
   (>= (length arguments) 2)
   ;; There must be two required arguments and an even number of
   ;; keyword arguments, so there must be an even number of arguments.
   (evenp (length arguments))
   ;; Each keyword must be one of the ones allowed.
   (all-allowed-keywords-p (rest (rest arguments))
                           '(:start1 :end1 :start2 :end2))))

(defun parameter-name-from-keyword (keyword)
  (intern (symbol-name keyword) '#:futhark))

(defun make-keyword-bindings (remaining)
  (let ((seen-keywords '())
        (bindings '())
        (ignores '()))
    (loop for (keyword form) on remaining by #'cddr
          for parameter-name = (parameter-name-from-keyword keyword)
          do (if (member keyword seen-keywords :test #'eq)
                 (let ((variable (gensym)))
                   (push variable ignores)
                   (push `(,variable ,form) bindings))
                 (let ((variable (parameter-name-from-keyword keyword)))
                   (push keyword seen-keywords)
                   (push `(,variable ,form) bindings))))
    (values bindings ignores)))

(defun compute-one-string-compiler-macro (arguments callee-name)
  (let ((bindings '())
        (remaining arguments))
    (push `(string ,(pop remaining)) bindings)
    (multiple-value-bind (keyword-bindings ignores)
        (make-keyword-bindings remaining)
      (setf bindings (append keyword-bindings bindings))
      `(let ((start 0) (end nil))
         (declare (ignorable start end))
         (let ,(reverse bindings)
           (declare (ignore ,@ignores))
           (,callee-name string start end))))))

(defun compute-two-string-compiler-macro (arguments callee-name)
  (let ((bindings '())
        (remaining arguments))
    (push `(string1 ,(pop remaining)) bindings)
    (push `(string2 ,(pop remaining)) bindings)
    (multiple-value-bind (keyword-bindings ignores)
        (make-keyword-bindings remaining)
      (setf bindings (append keyword-bindings bindings))
      `(let ((start1 0) (end1 nil) (start2 0) (end2 nil))
         (declare (ignorable start1 end1 start2 end2))
         (let ,(reverse bindings)
           (declare (ignore ,@ignores))
           (,callee-name string1 string2 start1 end1 start2 end2))))))
