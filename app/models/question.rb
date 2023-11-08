# frozen_string_literal: true

class Question < ApplicationRecord
  include LinkConcern
  include VoteConcern
  include CommentConcern

  belongs_to :user

  has_many :subscriptions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :subscribe_author

  def subscribe_author
    user.subscriptions.create(question: self)
  end
end
