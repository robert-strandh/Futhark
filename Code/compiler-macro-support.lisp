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
