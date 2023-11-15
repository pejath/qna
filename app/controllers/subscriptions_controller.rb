# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.subscriptions.create(question:)
  end

  def destroy
    current_user.subscriptions.find_by(question:)&.destroy
  end

  private

  def question
    @question ||= params['question_id'] ? Question.find(params['question_id']) : Question.new
  end
end
