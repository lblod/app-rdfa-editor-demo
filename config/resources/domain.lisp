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

(define-resource editor-document ()
  :class (s-prefix "notable:EditorDocument")
  :properties `((:title :string ,(s-prefix "dct:title"))
                (:content :string ,(s-prefix "ext:content"))
                (:created-on :datetime ,(s-prefix "pav:createdOn"))
                (:modified-on :datetime ,(s-prefix "pav:modifiedOn"))
                (:context :string ,(s-prefix "ext:editorDocumentContext")))
  :has-one `((folder :via ,(s-prefix "nfo:belongsToContainer")
                     :as "folder"))
  :resource-base (s-url "http://data.notable.redpencil.io/editor-documents/")
  :on-path "editor-documents")

(define-resource folder ()
  :class (s-prefix "nfo:Folder")
  :properties `((:label :string ,(s-prefix "skos:label")))
  :has-many `((editor-document :via ,(s-prefix "nfo:belongsToContainer")
                               :inverse t
                               :as "editor-documents")
              (folder :via ,(s-prefix "ext:parentFolder")
                      :inverse t
                      :as "children"))
  :has-one `((folder :via ,(s-prefix "ext:parentFolder")
                     :as "parent"))
  :resource-base (s-url "http://data.notable.redpencil.io/folders/")
  :on-path "folders")

(define-resource meeting ()
  :class (s-prefix "notable:Meeting")
  :properties `((:started-at :datetime ,(s-prefix "prov:startedAtTime"))
                (:ended-at :datetime ,(s-prefix "prov:endedAtTime"))
                (:location :url ,(s-prefix "prov:atLocation")))
  :has-many `((membership :via ,(s-prefix "notable:meetingAttendee")
                          :as "meeting-attendee")
              (agenda :via ,(s-prefix "notable:agenda")
                      :as "agenda"))
  :has-one `((editor-document :via ,(s-prefix "notable:hasMeetingNotes")
                              :as "meeting-notes"))
  :resource-base (s-url "http://data.notable.redpencil.io/meeting/")
  :on-path "meetings")

(define-resource membership ()
  :class (s-prefix "org:Membership")
  :has-one `((person :via ,(s-prefix "org:member")
                     :as "member")
             (role :via ,(s-prefix "org:role")
                   :as "role"))
  :resource-base (s-url "http://data.notable.redpencil.io/membership/")
  :on-path "memberships")

(define-resource person ()
  :class (s-prefix "foaf:Person")
  :properties `((:lastName :string ,(s-prefix "foaf:lastName"))
                (:firstName :string ,(s-prefix "foaf:firstName")))
  :resource-base (s-url "http://data.notable.redpencil.io/person/")
  :on-path "persons")

(define-resource role ()
  :class (s-prefix "org:Role")
  :properties `((:label :string ,(s-prefix "skos:prefLabel"))
                (:scope-note :string ,(s-prefix "skos:scopeNote")))
  :resource-base (s-url "http://data.notable.redpencil.io/role/")
  :on-path "roles")

(define-resource agenda ()
  :class (s-prefix "notable:Agenda")
  :has-many `((agenda-item :via ,(s-prefix "notable:agendaItem")
                           :as "agenda-items"))
  :resource-base (s-url "http://data.notable.redpencil.io/agenda-item/")
  :features '(include-uri)
  :on-path "agendas")

(define-resource agenda-item ()
  :class (s-prefix "notable:AgendaItem")
  :properties `((:description :string ,(s-prefix "dct:description"))
                (:title :string ,(s-prefix "dct:title"))
                (:position :int ,(s-prefix "schema:position")))
  :has-one `((agenda-item-proceedings :via ,(s-prefix "dct:subject")
                                      :inverse t
                                      :as "agenda-item-proceedings"))
  :resource-base (s-url "http://data.lblod.info/id/agenda-item/")
  :features '(include-uri)
  :on-path "agenda-items")

(define-resource agenda-item-proceedings ()
  :class (s-prefix "notable:AgendaItemProceedings")
  :properties `((:discussion :string ,(s-prefix "prov:value")))
  :has-one `((agenda-item :via ,(s-prefix "dct:subject")
                          :as "subject"))
  ;;you could also add references to e.g. other agendapoints, memberships etc.
  ;;But KISS for now
  :has-many `((action-item :via ,(s-prefix "notable:AgendaItemProceedingsActionItem")
                           :as "action-item"))
  :resource-base (s-url "http://data.lblod.info/id/agenda-item-proceedings/")
  :features '(include-uri)
  :on-path "agenda-item-proceedings")

(define-resource action-item ()
  :class (s-prefix "pdo:ActionItem")
  :properties `((:description :string ,(s-prefix "pdo:hasDescription"))
                (:end-time :datetime  ,(s-prefix "pdo:hasEndTime"))
                (:status :bool ,(s-prefix "pdo:hasStatus")))

  :has-one `((membership :via ,(s-prefix "notable:actionItemOwner")
                         :as "owner"))

  :resource-base (s-url "http://data.lblod.info/id/action-item/")
  :features '(include-uri)
  :on-path "action-items")
