class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  after_update :send_message_on_event

  private

  def send_message_on_event
    TextMessenger.new(
      account_sid: ENV['TWILIO_ACCOUNT_SID'],
      auth_token: ENV['TWILIO_AUTH_TOKEN'],
      account_phone_number: ENV['TWILIO_PHONE_NUMBER']
    ).send_message(phone_number, 'Your account has been updated.')
  end

end
