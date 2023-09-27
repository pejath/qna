# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  expose :question
  expose :answer

  def create
    answer.question = question
    answer.user_id = current_user.id

    if answer.save
      redirect_to answer.question, notice: 'Your answer successfully created.'
    else
      redirect_to answer.question, notice: answer.errors.full_messages
    end
  end

  def destroy
    if current_user.id == answer.user_id
      answer.destroy
      flash[:notice] = 'The answer was successfully destroyed.'
      redirect_to answer.question
    else
      redirect_to answer.question, notice: 'Only an author can do it.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
