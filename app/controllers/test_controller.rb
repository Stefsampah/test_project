class TestController < ApplicationController
  before_action :authenticate_user!
  
  def test_action
    @message = "Test controller fonctionne !"
    render plain: @message
  end
  
  def test_rewards
    @message = "Test rewards action fonctionne !"
    render plain: @message
  end
end
