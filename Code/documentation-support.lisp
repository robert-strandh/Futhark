(cl:in-package #:futhark)

(defparameter *string1-and-string2-are-string-designators*
  (format nil
          "STRING1 and STRING2 must be string designators.~@
           ~@
           Recall that a string designator is either a string,~@
           (designating itself), a symbol (designating its~@
           SYMBOL-NAME), or a character (designating a string~@
           of length 1 containing that character."))

(defparameter *string-is-a-string-designator*
  (format nil
          "STRING must be a string designator.~@
           ~@
           Recall that a string designator is either a string,~@
           (designating itself), a symbol (designating its~@
           SYMBOL-NAME), or a character (designating a string~@
           of length 1 containing that character."))

(defparameter *this-function-calls-the-string-function*
  (format nil
          "This function calls the function STRING to turn~@
           a string designator into a string, the STRING~@
           function will signal an error of type TYPE-ERROR~@
           if its argument is not a string deignator."))

(defparameter *start1/2-and-end1/2-are-bounding-index-designators*
  (format nil
          "START1 and END1 must be bounding index designators~@
           for STRING1.  START2 and END2 must be bounding index~@
           designators for STRING2."))

(defparameter *start-and-end-are-bounding-index-designators*
  (format nil
          "START and END must be bounding index designators~@
           for STRING."))

(defparameter *definition-of-bounding-index-designators*
  (format nil
          "Recall that two values S and E are valid bounding~@
           index designators for some string if and only if~@
           each of S and E is an integer between 0 and the~@
           length of the string (inclusive), and S is less than~@
           or equal to E.  The interval designated is the one~@
           that starts with index S and ends with index E-1."))

(defparameter *a-string-is-less*
  (format nil
          "A string A is less than a string B if in the first~@
           position in which they differ, the character of A~@
           is less than the corresponding character of B, or~@
           if A is a proper prefix of B.  If the interval of~@
           STRING1 designated by START1 and END1 is less than~@
           the interval of STRING2 designated by START2 and END2~@
           according to this definition, then this function returns~@
           the index of the first position at which the two~@
           intervals differ, as a an offset from the start of~@
           STRING1."))

(defparameter *a-string-is-greater*
  (format nil
          "A string A is greater than a string B if in the first~@
           position in which they differ, the character of A~@
           is greater than the corresponding character of B, or~@
           if B is a proper prefix of A.  If the interval of~@
           STRING1 designated by START1 and END1 is greater than~@
           the interval of STRING2 designated by START2 and END2~@
           according to this definition, then this function returns~@
           the index of the first position at which the two~@
           intervals differ, as a an offset from the start of~@
           STRING1."))

(defparameter *if-strings-are-not-equal*
  (format nil
          "If the interval of STRING1 designated by START1 and~@
           END1 is not equal to the interval of STRING2 designated~@
           by START2 and END2, then this function returns the index~@
           of the first position at which the two intervals differ,~@
           as a an offset from the start of STRING1.  Otherwise~@
           this function returns NIL.  The characters are compared~@
           using the function"))

; LocalWords:  designator designators
