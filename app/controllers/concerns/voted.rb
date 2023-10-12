# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern
  included { before_action :set_votable, only: %i[vote upvote downvote unvote] }

  def vote
    send(params[:vote_action]) unless current_user&.is_author?(@votable)
    render json: { id: @votable.id, rating: @votable.rating }
  end

  private

  def upvote
    @votable.upvote(current_user)
  end

  def downvote
    @votable.downvote(current_user)
  end

  def unvote
    @votable.remove_vote(current_user)
  end

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end
