require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get chats_show_url
    assert_response :success
  end

  test "should get creat" do
    get chats_creat_url
    assert_response :success
  end
end
