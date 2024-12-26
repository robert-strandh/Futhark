(cl:in-package #:futhark)

(defun one-string-compiler-macro-possible-p (arguments)
  ;; There must be at least one argument.
  (unless (>= (length arguments) 1)
    (return-from one-string-compiler-macro-possible-p nil))
  ;; There must be one required argument and an even number of keyword
  ;; arguments, so there must be an odd number of arguments.
  (unless (oddp (length arguments))
    (return-from one-string-compiler-macro-possible-p nil))
  ;; Each keyword must be one of the ones allowed.
  (loop for keyword in (cddr arguments) by #'cddr
        unless (member keyword '(:start :end))
          do (return-from one-string-compiler-macro-possible-p nil))
  t)

(defun two-string-compiler-macro-possible-p (arguments)
  ;; There must be at least two arguments.
  (unless (>= (length arguments) 2)
    (return-from two-string-compiler-macro-possible-p nil))
  ;; There must be two required arguments and an even number of
  ;; keyword arguments, so there must be an even number of arguments.
  (unless (evenp (length arguments))
    (return-from two-string-compiler-macro-possible-p nil))
  ;; Each keyword must be one of the ones allowed.
  (loop for keyword in (cddr arguments) by #'cddr
        unless (member keyword '(:start1 :end1 :start2 :end2))
          do (return-from two-string-compiler-macro-possible-p nil))
  t)

(defun find-variable (parameter dictionary)
  (cdr (assoc parameter dictionary :test #'eq)))

;;; Given a list of parameters, create a dictionary for translating
;;; each one into a unique generated symbol.
(defun make-dictionary (parameters)
  (loop for parameter in parameters
        collect (cons parameter (gensym))))

(defun parameter-name-from-keyword (keyword)
  (intern (symbol-name keyword) '#:futhark))

(defun make-keyword-bindings (remaining dictionary)
  (let ((seen-keywords '())
        (bindings '())
        (ignores '()))
    (loop for (keyword form) on remaining by #'cddr
          for parameter-name = (parameter-name-from-keyword keyword)
          do (if (member keyword seen-keywords :test #'eq)
                 (let ((variable (gensym)))
                   (push variable ignores)
                   (push (list variable form) bindings))
                 (let ((variable (find-variable parameter-name dictionary)))
                   (push keyword seen-keywords)
                   (push (list variable form) bindings))))
    (values bindings ignores)))

(defun compute-one-string-compiler-macro (arguments callee-name)
  (let ((dictionary (make-dictionary '(string start end)))
        (bindings '())
        (ignores '())
        (remaining arguments))
    (push (list (find-variable 'string dictionary) (pop remaining))
          bindings)
    (multiple-value-bind (keyword-bindings keyword-ignores)
        (make-keyword-bindings remaining dictionary)
      (setf bindings (append keyword-bindings bindings))
      (setf ignores (append keyword-ignores ignores)))
    (let ((gensyms (mapcar #'cdr dictionary)))
      `(let ((,(find-variable 'start dictionary) 0)
             (,(find-variable 'end dictionary) nil))
         (declare (ignorable ,@(cdr gensyms)))
         (let ,(reverse bindings)
           (declare (ignore ,@ignores))
           (,callee-name ,@gensyms))))))

(defun compute-two-string-compiler-macro (arguments callee-name)
  (let ((dictionary
          (make-dictionary '(string1 string2 start1 end1 start2 end2)))
        (bindings '())
        (ignores '())
        (remaining arguments))
    (push (list (find-variable 'string1 dictionary) (pop remaining))
          bindings)
    (push (list (find-variable 'string2 dictionary) (pop remaining))
          bindings)
    (multiple-value-bind (keyword-bindings keyword-ignores)
        (make-keyword-bindings remaining dictionary)
      (setf bindings (append keyword-bindings bindings))
      (setf ignores (append keyword-ignores ignores)))
    (let ((gensyms (mapcar #'cdr dictionary)))
      `(let ((,(find-variable 'start1 dictionary) 0)
             (,(find-variable 'end1 dictionary) nil)
             (,(find-variable 'start2 dictionary) 0)
             (,(find-variable 'end2 dictionary) nil))
         (declare (ignorable ,@(cddr gensyms)))
         (let ,(reverse bindings)
           (declare (ignore ,@ignores))
           (,callee-name ,@gensyms))))))
