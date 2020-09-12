require 'test_helper'

class DoctorTest < ActiveSupport::TestCase
  test "a doctor object can be created successfully" do
    new_doctor = Doctor.new({
      name: "Sample Doctor",
      specialization: "Some specialization"
    })

    assert new_doctor.valid?

    new_doctor.save
    assert_not new_doctor.id.nil?
  end

  test "a doctor object cannot be created with errors" do
    new_doctor = Doctor.new

    assert_not new_doctor.valid?
    assert new_doctor.id.nil?
    assert new_doctor.errors.keys.include?(:name)
    assert new_doctor.errors.keys.include?(:specialization)
    assert new_doctor.errors.full_messages.include?("Name can't be blank")
    assert new_doctor.errors.full_messages.include?("Specialization can't be blank")
  end

  test "a doctor has appointments" do
    doctor = doctors(:one)
    assert_equal doctor.appointments.count, 1
    assert_equal doctor.appointments.first.id, appointments(:one).id
  end

  test "a doctor has patients" do
    doctor = doctors(:two)
    assert_equal doctor.patients.count, 1
    assert_equal doctor.patients.first.id, users(:two).id
  end
end
