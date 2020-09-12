class User < ApplicationRecord
  has_secure_password

  validates_uniqueness_of :email
  validates_presence_of :name, :email

  has_many :appointments
  has_many :doctors, through: :appointments
end
