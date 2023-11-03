# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: :show

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end
