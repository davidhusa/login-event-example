# Real-Time SMS Notification System with Rails 7

This example app allows users to create accounts with phone numbers. If the application has been configured with the account SID, auth token, and "sender" phone number of an active Twilio account it will send a text message to a registered user's given phone number if the user:
1) Logs in with a different IP address than their last login.
2) Logs in for the 100th time or another number of times divisible by 100.
3) Logs in on the weekend (on the Pacific Time zone)

The messages will be logged on the server even if you don't have Twilio credentials set up, look under "### LOGIN EVENT ###" in the server logs to see what text messages would be sent.

# Installation

1) Clone this repository

  `git clone git@github.com:davidhusa/login-event-example.git`

  `cd login-event-example`
2) Install ruby dependencies 

  `bundle install`
3) Initialize the database

  `rails db:create`

  `rails db:migrate`
4) Copy environment variable file

  `cp example.env .env`
5) Fill in `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, and `TWILIO_PHONE_NUMBER` based on your Twilio credentials.
6) Start the server

  `rails s`

Run tests with `rails test`.