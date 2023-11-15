# frozen_string_literal: true

module SearchHelper
  def commentable_source_link(resource)
    if resource.commentable.instance_of?(Question)
      link_to resource.body, resource.commentable
    else
      link_to resource.body, resource.commentable.question
    end
  end
end
