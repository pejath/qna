# frozen_string_literal: true

module ApplicationHelper
  def vote_display(resource)
    'hidden' if current_user.voted?(resource)
  end

  def unvote_display(resource)
    'hidden' unless current_user.voted?(resource)
  end
end
