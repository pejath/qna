# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show update destroy]

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @answer

    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @answer

    @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question ||= Question.find(params[:question_id])
  end

  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def pundit_user
    current_resource_owner
  end
end
