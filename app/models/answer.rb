# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, as: :linkable, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_the_best
    transaction do
      self.class.where(question_id: question_id).update_all(best: false)
      update(best: true)
    end
  end
end
