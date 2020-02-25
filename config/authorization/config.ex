alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.Accessibility.ByQuery, as: AccessByQuery
alias Acl.GraphSpec.Constraint.Resource.AllPredicates, as: AllPredicates
alias Acl.GraphSpec.Constraint.Resource.NoPredicates, as: NoPredicates
alias Acl.GraphSpec.Constraint.ResourceFormat, as: ResourceFormatConstraint
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do
  def user_groups do
    [
      # // PUBLIC
      %GroupSpec{
        name: "public",
        useage: [:read,:write,:read_for_write],
        access: %AlwaysAccessible{}, # TODO: Should be only for logged in users
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/public",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://www.w3.org/2000/01/rdf-schema#Class",
                        "http://www.w3.org/2000/01/rdf-schema#Property",
                        "http://mu.semte.ch/vocabularies/ext/Template",
                        "http://data.notable.redpencil.io/EditorDocument",
                        "http://data.notable.redpencil.io/Meeting",
                        "http://www.w3.org/ns/org#Membership",
                        "http://xmlns.com/foaf/0.1/Person",
                        "http://www.w3.org/ns/org#Role",
                        "http://data.notable.redpencil.io/Agenda",
                        "http://data.notable.redpencil.io/AgendaItem",
                        "http://data.notable.redpencil.io/AgendaItemProceedings",
                        "http://ontologies.smile.deri.ie/pdo#ActionItem",
                        "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#Folder"
                      ]
                    } }
                ] },
      # // CLEANUP
      #
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [:write],
        name: "clean"
      }
    ]
  end
end
