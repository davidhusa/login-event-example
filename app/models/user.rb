class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  validates :phone_number, presence: true

  after_create :send_message_on_event

  # This callback triggers after signing in
  def after_database_authentication
    send_message_on_event
  end

  # Returns the phone number for use in "sanitized_phone_number" field in user form
  def sanitized_phone_number
    self.phone_number
  end

  # Used in user form to set the phone number, removing all the dashes (and other non-digit characters in case the
  #  stimulus controller isn't working properly)
  def sanitized_phone_number=(value)
    self.phone_number = value.gsub(/\D/, '')
  end

  private

  def send_message_on_event
    if use_twilio?
      text_messenger.send_message(phone_number, event_messages.join(", "))
    end

    Rails.logger.info "### LOGIN EVENT ###\n#{phone_number}: #{event_messages.join(', ')}" unless event_messages.blank?
  end

  def text_messenger
    TextMessenger.new(
      account_sid: ENV['TWILIO_ACCOUNT_SID'],
      auth_token: ENV['TWILIO_AUTH_TOKEN'],
      account_phone_number: ENV['TWILIO_PHONE_NUMBER']
    )
  end

  def event_messages
    event_messages = []
    if current_sign_in_ip && last_sign_in_ip && current_sign_in_ip != last_sign_in_ip
      event_messages << "Your account was accessed from a new IP address (#{current_sign_in_ip})"
    end

    if sign_in_count && sign_in_count > 0 && sign_in_count % 100 == 0
      event_messages << "Congratulations! You have signed in #{sign_in_count} times!!!!!!!!!"
    end

    sign_in_time = current_sign_in_at || Time.current

    if sign_in_time.saturday? || sign_in_time.sunday?
      event_messages << "You signed in on the weekend!"
    end

    event_messages
  end

  def use_twilio?
    ENV['TWILIO_ACCOUNT_SID'].present? && ENV['TWILIO_AUTH_TOKEN'].present? && ENV['TWILIO_PHONE_NUMBER'].present?
  end
end
