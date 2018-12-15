require 'dotenv/load'
require 'sinatra'

require 'httparty'
require 'byebug'

require_relative 'app/slack_authorizer'

use SlackAuthorizer

class BerMode < Sinatra::Base

  post '/slack/command' do
    response_url = params["response_url"]
    username = params["user_name"]
    contents = params["text"].split(" ")
    
    contents.each do |content|
      return if content.empty?
      options  = {
        body: {
          "response_type": "in_channel",
          "text": content,
          "username": username,
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      }
      HTTParty.post(response_url, options)
    end
    ""
  end

end