class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def simplified_stats
    @user = current_user
  end

  private

  def set_user
    @user = current_user
  end
end
