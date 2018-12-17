require 'dotenv/load'
require 'sinatra'

require 'httparty'
require 'byebug'

require 'thread'

require_relative 'app/slack_authorizer'

use SlackAuthorizer

class BerMode < Sinatra::Base

  post '/slack/command' do
    response_url = params["response_url"]
    username = params["user_name"]
    contents = params["text"].split(" ")
    
    threads = []
    contents.each_with_index do |content, index|
      return if content.empty?
      options  = {
        body: {
          "response_type": "in_channel",
          "text": content,
          "username": username,
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      }
      puts index
      threads << Thread.new { sleep(index); HTTParty.post(response_url, options) }
    end
    #threads.each(&:join)
    puts "end of function"
    ""
  end

end