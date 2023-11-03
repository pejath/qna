# frozen_string_literal: true

class QuestionsSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :user_id, :created_at, :updated_at, :short_title
  has_many :answers
  belongs_to :user

  def short_title
    object.title.truncate(4)
  end
end
