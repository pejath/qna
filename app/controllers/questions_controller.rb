# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :gon_question_id, only: :show
  before_action :gon_question_user_id, only: :show
  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: :create

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
    reward = Reward.new
    question.reward = reward
  end

  private

  def gon_question_id
    gon.question_id = question.id
  end

  def gon_question_user_id
    gon.question_user_id = question.user_id
  end

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast 'questions', question
  end

  def question_params
    params.require(:question).permit(:title, :body, :vote_action, files: [], links_attributes: %i[name url _destroy], reward_attributes: %i[title image])
  end
end
