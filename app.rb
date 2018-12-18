require 'dotenv/load'
require 'sinatra'

require 'httparty'
require 'byebug'

require 'thread'

require_relative 'app/slack_authorizer'

use SlackAuthorizer

class BerMode < Sinatra::Base

  post '/slack/command' do
    username = params["user_name"]
    contents = params["text"].split(" ")
    channel = "Ber"
    threads = []
    token = ENV["SLACK_API_TOKEN"]
    contents.each_with_index do |content, index|
      return if content.empty?
      threads << Thread.new { sleep(index * 0.4); result = HTTParty.get("https://slack.com/api/chat.postMessage?token=#{token}&channel=#{channel}&text=#{content}&username=#{username}&as_user=false&link_names=true"); puts result }
    end
    #threads.each(&:join)
    puts "end of function"
    ""
  end

end