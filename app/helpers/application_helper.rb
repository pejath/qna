# frozen_string_literal: true

module ApplicationHelper
  def vote_display(resource)
    'hidden' unless policy(resource).vote?
  end

  def unvote_display(resource)
    'hidden' if policy(resource).vote?
  end
end
