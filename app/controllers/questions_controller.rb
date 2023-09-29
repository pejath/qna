# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  expose :questions, -> { Question.all }
  expose :question

  expose :answers, from: :question
  expose :answer, -> { Answer.new }

  def destroy
    question.destroy

    redirect_to questions_path
  end

  def update
    question.update(question_params)
  end

  def create
    question.user = current_user

    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
