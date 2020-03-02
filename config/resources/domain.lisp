(in-package :mu-cl-resources)
(defparameter *cache-count-queries* nil)
(defparameter *supply-cache-headers-p* t
  "when non-nil, cache headers are supplied.  this works together with mu-cache.")
;;(setf *cache-model-properties-p* t)
(defparameter *include-count-in-paginated-responses* t
  "when non-nil, all paginated listings will contain the number
   of responses in the result object's meta.")
(defparameter *max-group-sorted-properties* nil)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  INCLUDES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(read-domain-file "generic-model-plugin-domain.lisp")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TEMPLATES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-resource template ()
  :class (s-prefix "ext:Template")
  :properties `((:title :string ,(s-prefix "dct:title"))
                (:matches :string-set ,(s-prefix "ext:templateMatches"))
                (:body :string ,(s-prefix "ext:templateContent"))
                (:contexts :uri-set ,(s-prefix "ext:activeInContext"))
                (:disabled-in-contexts :uri-set ,(s-prefix "ext:disabledInContext")))
  :resource-base (s-url "http://lblod.info/templates/")
  :features `(no-pagination-defaults)
  :on-path "templates")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DOCUMENTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-resource document ()
  :class (s-prefix "foaf:Document")
  :properties `((:date :datetime ,(s-prefix "dct:created")))
  :resource-base (s-url "http://data.notable.redpencil.io/document/")
  :features '(include-uri)
  :on-path "documents")