require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get verify" do
    get :verify
    assert_response :success
  end

end
