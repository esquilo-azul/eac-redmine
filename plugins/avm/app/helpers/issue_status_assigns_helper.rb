module IssueStatusAssignsHelper
  def options_for_association_conditions(association, record)
    if association.name == :issue_field
      { type: 'IssueCustomField', field_format: 'user' }
    else
      super
    end
  end
end
