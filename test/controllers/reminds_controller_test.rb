require 'test_helper'

class RemindsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @remind = reminds(:one)
  end

  test "should get index" do
    get reminds_url
    assert_response :success
  end

  test "should get new" do
    get new_remind_url
    assert_response :success
  end

  test "should create remind" do
    assert_difference('Remind.count') do
      post reminds_url, params: { remind: { body: @remind.body, email_id: @remind.email_id, schedule: @remind.schedule, title: @remind.title } }
    end

    assert_redirected_to remind_url(Remind.last)
  end

  test "should show remind" do
    get remind_url(@remind)
    assert_response :success
  end

  test "should get edit" do
    get edit_remind_url(@remind)
    assert_response :success
  end

  test "should update remind" do
    patch remind_url(@remind), params: { remind: { body: @remind.body, email_id: @remind.email_id, schedule: @remind.schedule, title: @remind.title } }
    assert_redirected_to remind_url(@remind)
  end

  test "should destroy remind" do
    assert_difference('Remind.count', -1) do
      delete remind_url(@remind)
    end

    assert_redirected_to reminds_url
  end
end
