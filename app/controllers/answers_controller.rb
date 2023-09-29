# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
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

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
