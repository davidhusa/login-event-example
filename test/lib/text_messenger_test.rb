require 'minitest/autorun'
require 'twilio-ruby'
require 'text_messenger'

class TextMessengerTest < Minitest::Test
  def setup
    @account_sid = 'account_sid'
    @auth_token = 'auth_token'
    @account_phone_number = '1234567890'
    @to = '1987654321'
    @body = 'hello there!'

    @messages = Minitest::Mock.new
    @client = Minitest::Mock.new
    @client.expect(:messages, @messages)

    Twilio::REST::Client.stub :new, @client do
      @text_messenger = TextMessenger.new(
        account_sid: @account_sid,
        auth_token: @auth_token, account_phone_number: @account_phone_number)
    end
  end

  def test_send_message
    @messages.expect(:create, nil, [{body: @body, to: @to, from: @account_phone_number}])

    @text_messenger.send_message(@to, @body)

    @client.verify
    @messages.verify
  end
end
