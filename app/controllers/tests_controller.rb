class TestsController < ApplicationController
    def check_user
      render json: { current_user: current_user }
    end
  end
  

