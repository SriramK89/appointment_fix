require 'openssl'
require 'base64'

class User < ApplicationRecord
  has_secure_password

  validates_uniqueness_of :email
  validates_presence_of :name, :email

  has_many :appointments
  has_many :doctors, through: :appointments

  KEY_SPLIT = '::'

  def self.get_from_api_token(api_token)
    user_id_email = CACHE.read(api_token)
    if user_id_email
      user_id, user_email = user_id_email.split(KEY_SPLIT)
      User.where(id: user_id, email: user_email).first
    end
  end

  def generate_api_token
    api_token = formulate_api_token
    CACHE.write(api_token, "#{id}#{KEY_SPLIT}#{email}", expires_in: 24.hours)
    api_token
  end

  def destroy_api_token(api_token)
    CACHE.delete(api_token)
  end

  private

    def formulate_api_token
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31])
      crypt.encrypt_and_sign("#{Time.now.to_i}-#{id}-#{email}").gsub(/([\/\+-=]+)/, '')
    end
end
