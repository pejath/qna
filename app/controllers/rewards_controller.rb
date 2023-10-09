class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    current_user.rewards
  end
end
