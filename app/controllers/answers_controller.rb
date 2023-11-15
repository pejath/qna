# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!

  before_action :set_answer, only: %i[update destroy mark_the_best]
  after_action :publish_answer, only: :create

  def create
    @answer = Answer.new(answer_params)
    @answer.question = question
    @answer.user_id = current_user.id
    @answer.save
  end

  def update
    @answers = @answer.question.answers
    @answer.update(answer_params)
  end

  def destroy
    @answers = @answer.question.answers
    @answer.destroy
  end

  def mark_the_best
    @answer.mark_the_best
    return unless @answer.question.reward

    @answer.question.reward.user = @answer.user
    @answer.question.reward.save
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "question_#{@answer.question.id}_answers", @answer
  end

  def answer_params
    params.require(:answer).permit(:body, :vote_action, files: [], links_attributes: %i[id name url _destroy])
  end
end
