# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner

    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @question

    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @question

    @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question ||= Question.find(params[:id])
  end
end
