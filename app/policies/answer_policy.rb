# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  def edit?
    user&.admin? || record.user_id == user&.id
  end

  def vote?
    return false unless user

    record.user_id != @user.id
  end
end
