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
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def create
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
