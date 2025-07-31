require "test_helper"

class ScannerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scanner_index_url
    assert_response :success
  end

  test "should get confirm" do
    get scanner_confirm_url
    assert_response :success
  end

  test "should get register_attendance" do
    get scanner_register_attendance_url
    assert_response :success
  end
end
