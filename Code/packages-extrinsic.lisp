(cl:in-package #:common-lisp-user)

(defpackage #:futhark
  (:use #:common-lisp)
  (:shadow
   . #1=(#:string
         #:string=
         #:string-equal
         #:string/=
         #:string-not-equal
         #:string<
         #:string-lessp
         #:string>
         #:string-greaterp
         #:string<=
         #:string-not-greaterp
         #:string>=
         #:string-not-lessp
         #:nstring-upcase
         #:string-upcase
         #:nstring-downcase
         #:string-downcase
         #:nstring-capitalize
         #:string-capitalize))
  (:export
   . #1#))
