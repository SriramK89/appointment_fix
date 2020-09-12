class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :user

  validates_presence_of :time_from, :time_to
  validate :fixing_unique_appointments

  def fixing_unique_appointments
    if Appointment.where('? <  time_to and ? > time_from', self.time_from, self.time_to).any?
      self.errors.add(:time_duration, "cannot be conflicting")
    end
  end
end
