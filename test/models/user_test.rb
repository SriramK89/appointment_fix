require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "an user object can be created successfully" do
    new_user = User.new({
      name: "Sample user",
      email: "sample.user@somemail.com",
      password: "sample_password",
      password_confirmation: "sample_password"
    })

    assert new_user.valid?

    new_user.save
    assert_not new_user.id.nil?
  end

  test "an user object cannot be created with errors" do
    new_user = User.new

    assert_not new_user.valid?
    assert new_user.id.nil?
    assert new_user.errors.keys.include?(:name)
    assert new_user.errors.keys.include?(:email)
    assert new_user.errors.keys.include?(:password)
    assert new_user.errors.full_messages.include?("Name can't be blank")
    assert new_user.errors.full_messages.include?("Email can't be blank")
    assert new_user.errors.full_messages.include?("Password can't be blank")
  end

  test "an user has appointments" do
    user = users(:one)
    assert_equal user.appointments.count, 1
    assert_equal user.appointments.first.id, appointments(:one).id
  end

  test "a user has doctors" do
    user = users(:two)
    assert_equal user.doctors.count, 1
    assert_equal user.doctors.first.id, doctors(:two).id
  end
end
