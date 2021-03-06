(define-resource rdfs-class ()
  :class (s-prefix "rdfs:Class")
  :properties `((:label :string ,(s-prefix "rdfs:label"))
                (:description :string ,(s-prefix "rdfs:comment"))
                (:api-path :string ,(s-prefix "ext:apiPath"))
                (:display-properties :string ,(s-prefix "ext:displayProperties"))
                (:base-uri :string ,(s-prefix "ext:baseUri"))
                (:api-filter :string ,(s-prefix "ext:apiFilter"))
                (:is-primitive :bool ,(s-prefix "ext:isPrimitive"))
                (:rdfa-type :uri ,(s-prefix "ext:rdfaType"))
                (:json-api-type :string ,(s-prefix "ext:jsonApiType")))

  :has-many `((rdfs-property :via ,(s-prefix "ext:rdfsClassProperties")
                        :as "properties"))

  :resource-base (s-url "http://data.lblod.info/id/rdfs-classes/")
  :features '(include-uri)
  :on-path "rdfs-classes")

(define-resource rdfs-property ()
  :class (s-prefix "rdfs:Property")
  :properties `((:label :string ,(s-prefix "rdfs:label"))
                (:rdfa-type :uri ,(s-prefix "ext:rdfaType")))
  :has-many `((rdfs-class :via ,(s-prefix "ext:rdfsClassProperties")
                     :inverse t
                     :as "domain"))
  :has-one `((rdfs-class :via ,(s-prefix "rdfs:range")
                     :as "range"))
  :resource-base (s-url "http://data.lblod.info/id/rdfs-properties/")
  :features '(include-uri)
  :on-path "rdfs-properties")
