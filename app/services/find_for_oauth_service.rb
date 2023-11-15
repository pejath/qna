# frozen_string_literal: true

class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    return unless email

    user = User.where(email:).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email:, password:, password_confirmation: password)
      user.skip_confirmation!
      user.confirm
    end
    user.create_autorization(auth)

    user
  end
end
