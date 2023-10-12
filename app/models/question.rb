# frozen_string_literal: true

class Question < ApplicationRecord
  include LinkConcern
  include VoteConcern

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many_attached :files

  validates :title, :body, presence: true
end
