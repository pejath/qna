# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  after_action :publish_answer, only: :create

  expose :question
  expose :answer

  def create
    answer.question = question
    answer.user_id = current_user.id
    answer.save
  end

  def update
    @answers = answer.question.answers
    answer.update(answer_params)
  end

  def destroy
    @answers = answer.question.answers
    answer.destroy
  end

  def mark_the_best
    answer.mark_the_best
    question.reward.user = answer.user
    question.reward.save
  end

  private

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast "question_#{question.id}_answers", answer
  end

  def answer_params
    params.require(:answer).permit(:body, :vote_action, files: [], links_attributes: %i[name url _destroy])
  end
end
