require 'test_helper'

class AppointmentsControllerTest < ActionController::TestCase
  test "should create an appointment" do
    user = users(:one)
    doctor = doctors(:one)
    api_token = user.generate_api_token
    time_from = (DateTime.now + 1.month).strftime(TIME_FORMAT)
    time_to = (DateTime.now + 1.month + 2.hours).strftime(TIME_FORMAT)

    request.headers['Authorization'] = api_token
    process :create, method: :post, params: {
      doctor_id: doctor.id,
      time_from: time_from,
      time_to: time_to
    }
    assert_response :success

    assert json_response.has_key?('appointment')
    assert json_response['appointment'].has_key?('id')
    assert json_response['appointment'].has_key?('doctor_id')
    assert json_response['appointment'].has_key?('time_from')
    assert json_response['appointment'].has_key?('time_to')

    assert_equal json_response['appointment']['doctor_id'], doctor.id
    assert_equal json_response['appointment']['time_from'], time_from
    assert_equal json_response['appointment']['time_to'], time_to
  end

  test 'should not create an appointment without an user' do
    request.headers['Authorization'] = nil
    process :create, method: :post
    assert_response :unauthorized

    assert json_response.has_key?('error')

    assert_equal json_response['error'], 'Invalid API token'
  end

  test 'should not create an appointment without a doctor' do
    user = users(:one)
    api_token = user.generate_api_token

    request.headers['Authorization'] = api_token
    process :create, method: :post
    assert_response :not_found

    assert json_response.has_key?('error')

    assert_equal json_response['error'], 'Doctor not found'
  end

  test 'should not create an appointment without proper time format' do
    user = users(:one)
    doctor = doctors(:one)
    api_token = user.generate_api_token

    request.headers['Authorization'] = api_token
    process :create, method: :post, params: {
      doctor_id: doctor.id,
      time_from: (DateTime.now + 1.month).strftime('%Y-%m-%dT%H:%M:%S'),
      time_to: (DateTime.now + 1.month + 2.hours).strftime('%Y-%m-%dT%H:%M:%S')
    }
    assert_response :bad_request

    assert json_response.has_key?('error')

    assert_equal json_response['error'], 'Accepted time format `YYYY-MM-DDTHH:MM:SS+ZZZZ`'
  end

  test 'should not create an appointment with overlapping time' do
    user = users(:one)
    appointment = appointments(:one)
    doctor = appointment.doctor
    api_token = user.generate_api_token

    request.headers['Authorization'] = api_token
    process :create, method: :post, params: {
      doctor_id: doctor.id,
      time_from: (appointment.time_from).strftime(TIME_FORMAT),
      time_to: (appointment.time_to).strftime(TIME_FORMAT)
    }
    assert_response :bad_request

    assert json_response.has_key?('error')

    assert json_response['error'], 'Time duration cannot be conflicting'
  end

  test "should get index for all doctors and today" do
    process :index, method: :get, params: { time_frame: "today" }
    assert_response :success

    assert json_response.has_key?('appointments')
    if json_response['appointments'].count > 1
      assert_equal json_response['appointments'].count, 2

      assert json_response['appointments'][0].has_key?('id')
      assert json_response['appointments'][0].has_key?('doctor_id')
      assert json_response['appointments'][0].has_key?('user_id')
      assert json_response['appointments'][0].has_key?('time_from')
      assert json_response['appointments'][0].has_key?('time_to')
    end
  end

  test "should get index for a doctor and week" do
    doctor = doctors(:one)

    process :index, method: :get, params: { doctor_id: doctor.id, time_frame: "week" }
    assert_response :success

    assert json_response.has_key?('appointments')
    if json_response['appointments'].count > 1
      assert_equal json_response['appointments'].count, 2

      assert json_response['appointments'][0].has_key?('id')
      assert json_response['appointments'][0].has_key?('doctor_id')
      assert json_response['appointments'][0].has_key?('user_id')
      assert json_response['appointments'][0].has_key?('time_from')
      assert json_response['appointments'][0].has_key?('time_to')
    end
  end

  test "should get index for a doctor" do
    doctor = doctors(:one)

    process :index, method: :get, params: { doctor_id: doctor.id }
    assert_response :success

    assert json_response.has_key?('appointments')
    if json_response['appointments'].count > 1
      assert_equal json_response['appointments'].count, 2

      assert json_response['appointments'][0].has_key?('id')
      assert json_response['appointments'][0].has_key?('doctor_id')
      assert json_response['appointments'][0].has_key?('user_id')
      assert json_response['appointments'][0].has_key?('time_from')
      assert json_response['appointments'][0].has_key?('time_to')
    end
  end

end
