require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get hit" do
    get :hit
    assert_response :success
  end

  test "should get status" do
    get :status
    assert_response :success
  end

end
