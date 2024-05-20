require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new
    @user.email = "guy@internet.com"
    @user.password = "password"
    @user.phone_number = "1234567890"
    @user.save
  end

  test "All event messages" do
    @user.current_sign_in_ip = '192.168.1.1'
    @user.last_sign_in_ip = '192.168.1.2'
    @user.sign_in_count = 99
    @user.current_sign_in_at = Time.new(2022, 1, 1, 0, 0, 0) # a saturday

    expected_messages = [
      "Your account was accessed from a new IP address (192.168.1.1)",
      "Congratulations! You have signed in 100 times!!!!!!!!!",
      "You signed in on the weekend!"
    ]

    assert_equal expected_messages, @user.send(:event_messages)
  end

  def test_no_event_messages
    @user.current_sign_in_ip = '192.168.1.1'
    @user.last_sign_in_ip = '192.168.1.1'
    @user.sign_in_count = 1
    @user.current_sign_in_at = Time.new(2022, 1, 3, 0, 0, 0) # a monday

    assert @user.send(:event_messages).empty?
  end

  def test_use_twilio?
    ENV['TWILIO_ACCOUNT_SID'] = 'sid'
    ENV['TWILIO_AUTH_TOKEN'] = 'token'
    ENV['TWILIO_PHONE_NUMBER'] = 'phone_number'

    assert @user.send(:use_twilio?)

    ENV['TWILIO_ACCOUNT_SID'] = nil

    refute @user.send(:use_twilio?)
  end
end
