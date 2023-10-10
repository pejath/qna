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

  def show
    answer.links.new
  end

  def create
    question.user = current_user

    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def new
    question.links.new
    question.reward.new
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url _destroy], reward_attributes: %i[title image])
  end
end
