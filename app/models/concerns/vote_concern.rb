# frozen_string_literal: true

module VoteConcern
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def upvote(user)
    votes.find_or_create_by(user:, value: true)
  end

  def downvote(user)
    votes.find_or_create_by(user:, value: false)
  end

  def remove_vote(user)
    votes.delete_by(user:)
  end

  def rating
    votes.where(value: true).count - votes.where(value: false).count
  end
end
