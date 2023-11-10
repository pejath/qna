# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]

  before_action :set_question, only: %i[ show edit update destroy ]
  before_action :gon_question_id, only: :show
  before_action :gon_question_user_id, only: :show
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    authorize(@question)
    @question.update(question_params)
  end

  def destroy
    authorize(@question)

    @question.destroy

    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def gon_question_id
    gon.question_id = @question.id
  end

  def gon_question_user_id
    gon.question_user_id = @question.user_id
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast 'questions', @question
  end

  def question_params
    params.require(:question).permit(:title, :body, :vote_action, files: [], links_attributes: %i[id name url _destroy], reward_attributes: %i[id title image _destroy])
  end
end
