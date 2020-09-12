require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should create user session" do
    user = users(:one)

    process :create, method: :post, params: { email: user.email, password: 'testpassword1' }
    assert_response :success

    assert json_response.has_key?('api_token')
    assert json_response.has_key?('user')
    assert json_response['user'].has_key?('id')
    assert json_response['user'].has_key?('name')
    assert json_response['user'].has_key?('email')

    assert_equal json_response['user']['id'], user.id
    assert_equal json_response['user']['name'], user.name
    assert_equal json_response['user']['email'], user.email
  end

  test "should not create user session" do
    process :create, method: :post
    assert_response :unauthorized

    assert json_response.has_key?('error')
    assert_equal json_response['error'], 'Email/password does not match'
  end

  test "should destroy_session" do
    user = users(:one)
    api_token = user.generate_api_token

    request.headers['Authorization'] = api_token
    process :destroy_session, method: :delete

    assert_response :success

    assert json_response.has_key?('message')

    assert_equal json_response['message'], 'Logout successful'
  end

  test "should not destroy_session" do
    process :destroy_session, method: :delete

    assert_response :unauthorized

    assert json_response.has_key?('error')
    assert_equal json_response['error'], 'Invalid API token'
  end
end
