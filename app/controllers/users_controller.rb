# frozen_string_literal: true

class UsersController < ApplicationController
  def set_email
    return redirect_to root_path unless session[:oauth]

    password = Devise.friendly_token[0, 20]
    @user = User.new(email: user_params[:email], password:, password_confirmation: password)
    if @user.save
      @user.create_autorization(oauth)
      redirect_to root_path
    else
      render set_email_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def oauth
    Struct.new(:uid, :provider).new(session[:oauth]['uid'], session[:oauth]['provider'])
  end
end
