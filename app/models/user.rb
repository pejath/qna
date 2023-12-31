# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :rewards, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_autorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def voted?(resource)
    votes.where(votable_id: resource).present?
  end
end
