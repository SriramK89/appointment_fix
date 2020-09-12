require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  test "can create an appointment successfully" do
    appointment = Appointment.new({
      doctor: doctors(:one),
      user: users(:one),
      time_from: (Time.now + 1.day),
      time_to: (Time.now + 2.days)
    })

    assert appointment.valid?
    appointment.save
    assert_not appointment.id.nil?
  end

  test "cannot create appointment with errors" do
    appointment = Appointment.new

    assert_not appointment.valid?
    assert appointment.errors.has_key?(:doctor)
    assert appointment.errors.has_key?(:user)
    assert appointment.errors.has_key?(:time_from)
    assert appointment.errors.has_key?(:time_to)
    assert appointment.errors.full_messages.include?('Doctor must exist')
    assert appointment.errors.full_messages.include?('User must exist')
    assert appointment.errors.full_messages.include?('Time from can\'t be blank')
    assert appointment.errors.full_messages.include?('Time to can\'t be blank')

    appointment = appointments(:one).dup
    appointment.time_from += 1.hour
    appointment.time_to += 1.hour
    assert_not appointment.valid?
    assert appointment.errors.has_key?(:time_duration)
    assert appointment.errors.full_messages.include?('Time duration cannot be conflicting')
  end

  test "belongs to doctor" do
    appointment = appointments(:one)

    assert appointment.doctor
    assert_equal appointment.doctor_id, doctors(:one).id
  end

  test "belongs to user" do
    appointment = appointments(:one)

    assert appointment.user
    assert_equal appointment.user_id, users(:one).id
  end
end
