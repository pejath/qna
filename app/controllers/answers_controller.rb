# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :question
  expose :answer

  def create
    @new_answer = question.answers.new(answer_params)

    if @new_answer.save
      redirect_to @new_answer.question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
