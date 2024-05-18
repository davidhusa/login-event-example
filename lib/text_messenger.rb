require "twilio-ruby"

class TextMessenger
  def initialize(account_sid:, auth_token:, account_phone_number:)
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    @account_phone_number = "+#{account_phone_number}"
  end

  def send_message(to, body)
    @client.messages.create(
      body: body,
      to: "+#{to}",
      from: @account_phone_number
    )
  end
end
