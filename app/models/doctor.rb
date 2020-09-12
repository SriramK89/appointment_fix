class Doctor < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments, source: User.to_s.downcase

  validates_presence_of :name, :specialization
end
